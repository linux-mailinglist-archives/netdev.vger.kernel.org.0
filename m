Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE3315F8CE
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 15:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbfGDNEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 09:04:02 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:34140 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbfGDNEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 09:04:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=A8lube6VOC1n1Ro1DrRjg3Qay/jXwcb/kBxaGnfYb1I=; b=oP1/IB8pNI0kgtZF9ZuO6yzAf
        eeY2wLSdG3wfbjwRQnM0MsivnnKwO2DskCit2dD/Dr5mEpwttnCy59J576LlVL2vPJUNFGoibScb/
        dSZiBrJ2Kp6plaXBrKRseaj743DHcaBNXdsqHjAMUOe2Yezcx/sTn5DsuT/g9wnHOuB2c1L1de1Jz
        UmS5SQZawetrsQWgQRoHKXQFKZxqulrpSTQVT4lBHs8Be0/8GBO7aoMNW3dFAjPhN0IzqNnafPV9i
        zknuO2fWe31eQauOYZRxLdDqRmI5S248Ohx7yl3hrRGFkPxIsBoDEjbpERXxGnd8MUk0cjUcaH5OE
        XnttOPwFg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hj1Ok-0002Bb-Vm; Thu, 04 Jul 2019 13:03:39 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 3D10820AF0743; Thu,  4 Jul 2019 15:03:36 +0200 (CEST)
Date:   Thu, 4 Jul 2019 15:03:36 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Kris Van Hees <kris.van.hees@oracle.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        dtrace-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, mhiramat@kernel.org, acme@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, Chris Mason <clm@fb.com>
Subject: Re: [PATCH 1/1] tools/dtrace: initial implementation of DTrace
Message-ID: <20190704130336.GN3402@hirez.programming.kicks-ass.net>
References: <201907040313.x643D8Pg025951@userv0121.oracle.com>
 <201907040314.x643EUoA017906@aserv0122.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201907040314.x643EUoA017906@aserv0122.oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 03, 2019 at 08:14:30PM -0700, Kris Van Hees wrote:
> +/*
> + * Read the data_head offset from the header page of the ring buffer.  The
> + * argument is declared 'volatile' because it references a memory mapped page
> + * that the kernel may be writing to while we access it here.
> + */
> +static u64 read_rb_head(volatile struct perf_event_mmap_page *rb_page)
> +{
> +	u64	head = rb_page->data_head;
> +
> +	asm volatile("" ::: "memory");
> +
> +	return head;
> +}
> +
> +/*
> + * Write the data_tail offset in the header page of the ring buffer.  The
> + * argument is declared 'volatile' because it references a memory mapped page
> + * that the kernel may be writing to while we access it here.

s/writing/reading/

> + */
> +static void write_rb_tail(volatile struct perf_event_mmap_page *rb_page,
> +			  u64 tail)
> +{
> +	asm volatile("" ::: "memory");
> +
> +	rb_page->data_tail = tail;
> +}

That volatile usage is atrocious (kernel style would have you use
{READ,WRITE}_ONCE()). Also your comments fail to mark these as
load_acquire and store_release. And by only using a compiler barrier
you're hard assuming TSO, which is somewhat fragile at best.

Alternatively, you can use the C11 bits and write:

	return __atomic_load_n(&rb_page->data_head, __ATOMIC_ACQUIRE);

	__atomic_store_n(&rb_page->data_tail, tail, __ATOMIC_RELEASE);

> +/*
> + * Process and output the probe data at the supplied address.
> + */
> +static int output_event(int cpu, u64 *buf)
> +{
> +	u8				*data = (u8 *)buf;
> +	struct perf_event_header	*hdr;
> +
> +	hdr = (struct perf_event_header *)data;
> +	data += sizeof(struct perf_event_header);
> +
> +	if (hdr->type == PERF_RECORD_SAMPLE) {
> +		u8		*ptr = data;
> +		u32		i, size, probe_id;
> +
> +		/*
> +		 * struct {
> +		 *	struct perf_event_header	header;
> +		 *	u32				size;
> +		 *	u32				probe_id;
> +		 *	u32				gap;
> +		 *	u64				data[n];
> +		 * }
> +		 * and data points to the 'size' member at this point.
> +		 */
> +		if (ptr > (u8 *)buf + hdr->size) {
> +			fprintf(stderr, "BAD: corrupted sample header\n");
> +			goto out;
> +		}
> +
> +		size = *(u32 *)data;
> +		data += sizeof(size);
> +		ptr += sizeof(size) + size;
> +		if (ptr != (u8 *)buf + hdr->size) {
> +			fprintf(stderr, "BAD: invalid sample size\n");
> +			goto out;
> +		}
> +
> +		probe_id = *(u32 *)data;
> +		data += sizeof(probe_id);
> +		size -= sizeof(probe_id);
> +		data += sizeof(u32);		/* skip 32-bit gap */
> +		size -= sizeof(u32);
> +		buf = (u64 *)data;
> +
> +		printf("%3d %6d ", cpu, probe_id);
> +		for (i = 0, size /= sizeof(u64); i < size; i++)
> +			printf("%#016lx ", buf[i]);
> +		printf("\n");
> +	} else if (hdr->type == PERF_RECORD_LOST) {
> +		u64	lost;
> +
> +		/*
> +		 * struct {
> +		 *	struct perf_event_header	header;
> +		 *	u64				id;
> +		 *	u64				lost;
> +		 * }
> +		 * and data points to the 'id' member at this point.
> +		 */
> +		lost = *(u64 *)(data + sizeof(u64));
> +
> +		printf("[%ld probes dropped]\n", lost);
> +	} else
> +		fprintf(stderr, "UNKNOWN: record type %d\n", hdr->type);
> +
> +out:
> +	return hdr->size;
> +}

I see a distinct lack of wrapping support. AFAICT when buf+hdr->size
wraps you're doing out-of-bounds accesses.

> +/*
> + * Process the available probe data in the given buffer.
> + */
> +static void process_data(struct dtrace_buffer *buf)
> +{
> +	/* This is volatile because the kernel may be updating the content. */
> +	volatile struct perf_event_mmap_page	*rb_page = buf->base;
> +	u8					*base = (u8 *)buf->base +
> +							buf->page_size;
> +	u64					head = read_rb_head(rb_page);
> +
> +	while (rb_page->data_tail != head) {
> +		u64	tail = rb_page->data_tail;
> +		u64	*ptr = (u64 *)(base + tail % buf->data_size);
> +		int	len;
> +
> +		len = output_event(buf->cpu, ptr);
> +
> +		write_rb_tail(rb_page, tail + len);
> +		head = read_rb_head(rb_page);
> +	}
> +}

more volatile yuck.

Also:

	for (;;) {
		head = __atomic_load_n(&rb_page->data_head, __ATOMIC_ACQUIRE);
		tail = __atomic_load_n(&rb_page->data_tail, __ATOMIC_RELAXED);

		if (head == tail)
			break;

		do {
			hdr = buf->base + (tail & ((1UL << buf->data_shift) - 1));
			if ((tail >> buf->data_shift) !=
			    ((tail + hdr->size) >> buf->data_shift))
				/* handle wrap case */
			else
				/* normal case */

			tail += hdr->size;
		} while (tail != head);

		__atomic_store_n(&rb_page->data_tail, tail, __ATOMIC_RELEASE);
	}

Or something.

> +/*
> + * Wait for data to become available in any of the buffers.
> + */
> +int dt_buffer_poll(int epoll_fd, int timeout)
> +{
> +	struct epoll_event	events[dt_numcpus];
> +	int			i, cnt;
> +
> +	cnt = epoll_wait(epoll_fd, events, dt_numcpus, timeout);
> +	if (cnt < 0)
> +		return -errno;
> +
> +	for (i = 0; i < cnt; i++)
> +		process_data((struct dtrace_buffer *)events[i].data.ptr);
> +
> +	return cnt;
> +}

Or make sure to read on the CPU by having a poll thread per CPU, then
you can do away with the memory barriers.
