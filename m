Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36B4A339F28
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 17:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234082AbhCMQke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Mar 2021 11:40:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233671AbhCMQk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Mar 2021 11:40:29 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A0FC061574;
        Sat, 13 Mar 2021 08:40:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=sBCs4MtNfygVZXQx38012mKDNeN6bnlE4N7ZMxcBifA=; b=U80yIPKDP0mqtxaFr33115R24j
        GKvfSFdT1Huk+u6E51hd0uqrOCfjZ5LmT7XIpwMPpxRjfU/0AlWkFku+p9hF1fnxAbW/parHIVJuG
        NMk1KZyxAc1iGmdUiXDC+v3uevgCdNYStiqX/1N/9eDaYGKLIl9z3EUgNsAV6sEDz2pQ69iMt2ZJT
        PFST5nXcC6gKp5sKEceTdjAvZYZ8hHB4yEjl6hBlJ6p3dIyfTahjR/dnylkyt/xxjTY5H2xetO6Xu
        bJgbSSRDk368bB2TqqLM9tYhXkR6jaL7akY1Cdtxe+nN4cZ2FL2j5U3rllpWrqX/qyD2cTBTIJQGu
        DhBVkE2w==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lL7Ir-00EJ2k-JU; Sat, 13 Mar 2021 16:39:53 +0000
Date:   Sat, 13 Mar 2021 16:39:49 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH 2/5] mm/page_alloc: Add a bulk page allocator
Message-ID: <20210313163949.GI2577561@casper.infradead.org>
References: <20210310104618.22750-1-mgorman@techsingularity.net>
 <20210310104618.22750-3-mgorman@techsingularity.net>
 <20210310154650.ad9760cd7cb9ac4acccf77ee@linux-foundation.org>
 <20210311084200.GR3697@techsingularity.net>
 <20210312124609.33d4d4ba@carbon>
 <20210312145814.GA2577561@casper.infradead.org>
 <20210312160350.GW3697@techsingularity.net>
 <20210312210823.GE2577561@casper.infradead.org>
 <20210313131648.GY3697@techsingularity.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MGYHOYXEY6WxJCY8"
Content-Disposition: inline
In-Reply-To: <20210313131648.GY3697@techsingularity.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Mar 13, 2021 at 01:16:48PM +0000, Mel Gorman wrote:
> > I'm not claiming the pagevec is definitely a win, but it's very
> > unclear which tradeoff is actually going to lead to better performance.
> > Hopefully Jesper or Chuck can do some tests and figure out what actually
> > works better with their hardware & usage patterns.
> 
> The NFS user is often going to need to make round trips to get the pages it
> needs. The pagevec would have to be copied into the target array meaning
> it's not much better than a list manipulation.

I don't think you fully realise how bad CPUs are at list manipulation.
See the attached program (and run it on your own hardware).  On my
less-than-a-year-old core-i7:

$ gcc -W -Wall -O2 -g array-vs-list.c -o array-vs-list
$ ./array-vs-list 
walked sequential array in 0.001765s
walked sequential list in 0.002920s
walked sequential array in 0.001777s
walked shuffled list in 0.081955s
walked shuffled array in 0.007367s

If you happen to get the objects in-order, it's only 64% worse to walk
a list as an array.  If they're out of order, it's *11.1* times as bad.

--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="array-vs-list.c"

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>

unsigned long count = 1000 * 1000;
unsigned int verbose;

struct object {
	struct object *next;
	struct object *prev;
	unsigned int value;
};

#define printv(level, fmt, ...) \
	if (level <= verbose) { printf(fmt, ##__VA_ARGS__); }

void check_total(unsigned long total)
{
	if (total * 2 != count * (count + 1))
		printf("Check your staging! (%lu %lu)\n", total, count);
}

void alloc_objs(struct object **array)
{
	unsigned long i;

	for (i = 0; i < count; i++) {
		struct object *obj = malloc(sizeof(*obj));

		obj->value = i + 1;
		/* Add to the array */
		array[i] = obj;
	}
}

void shuffle(struct object **array, unsigned long seed)
{
	unsigned long i;

	printv(1, "random seed %lu\n", seed);
	srand48(seed);

	/* Shuffle the array */
	for (i = 1; i < count; i++) {
		struct object *obj;
		unsigned long j = (unsigned int)mrand48() % (i + 1);

		if (i == j)
			continue;
		obj = array[j];
		array[j] = array[i];
		array[i] = obj;
	}
}

void create_list(struct object **array, struct object *list)
{
	unsigned long i;

	list->next = list;
	list->prev = list;

	for (i = 0; i < count; i++) {
		struct object *obj = array[i];
		/* Add to the tail of the list */
		obj->next = list;
		obj->prev = list->prev;
		list->prev->next = obj;
		list->prev = obj;
	}
}

void walk_list(struct object *list)
{
	unsigned long total = 0;
	struct object *obj;

	for (obj = list->next; obj != list; obj = obj->next) {
		total += obj->value;
	}

	check_total(total);
}

void walk_array(struct object **array)
{
	unsigned long total = 0;
	unsigned long i;

	for (i = 0; i < count; i++) {
		total += array[i]->value;
	}

	check_total(total);
}

/* time2 - time1 */
double diff_time(struct timespec *time1, struct timespec *time2)
{
	double result = time2->tv_nsec - time1->tv_nsec;

	return time2->tv_sec - time1->tv_sec + result / 1000 / 1000 / 1000;
}

int main(int argc, char **argv)
{
	int opt;
	unsigned long seed = time(NULL);
	struct object **array;
	struct object list;
	struct timespec time1, time2;

	while ((opt = getopt(argc, argv, "c:s:v")) != -1) {
		if (opt == 'c')
			count *= strtoul(optarg, NULL, 0);
		else if (opt == 's')
			seed = strtoul(optarg, NULL, 0);
		else if (opt == 'v')
			verbose++;
	}

	clock_gettime(CLOCK_MONOTONIC, &time1);
	array = calloc(count, sizeof(void *));
	alloc_objs(array);
	clock_gettime(CLOCK_MONOTONIC, &time2);
	printv(1, "allocated %lu items in %fs\n", count,
			diff_time(&time1, &time2));

	clock_gettime(CLOCK_MONOTONIC, &time1);
	walk_array(array);
	clock_gettime(CLOCK_MONOTONIC, &time2);
	printf("walked sequential array in %fs\n",
			diff_time(&time1, &time2));

	clock_gettime(CLOCK_MONOTONIC, &time1);
	create_list(array, &list);
	clock_gettime(CLOCK_MONOTONIC, &time2);
	printv(1, "created list in %fs\n",
			diff_time(&time1, &time2));

	clock_gettime(CLOCK_MONOTONIC, &time1);
	walk_list(&list);
	clock_gettime(CLOCK_MONOTONIC, &time2);
	printf("walked sequential list in %fs\n",
			diff_time(&time1, &time2));

	clock_gettime(CLOCK_MONOTONIC, &time1);
	walk_array(array);
	clock_gettime(CLOCK_MONOTONIC, &time2);
	printf("walked sequential array in %fs\n",
			diff_time(&time1, &time2));

	clock_gettime(CLOCK_MONOTONIC, &time1);
	shuffle(array, seed);
	clock_gettime(CLOCK_MONOTONIC, &time2);
	printv(1, "shuffled array in %fs\n",
			diff_time(&time1, &time2));

	clock_gettime(CLOCK_MONOTONIC, &time1);
	create_list(array, &list);
	clock_gettime(CLOCK_MONOTONIC, &time2);
	printv(1, "created list in %fs\n",
			diff_time(&time1, &time2));

	clock_gettime(CLOCK_MONOTONIC, &time1);
	walk_list(&list);
	clock_gettime(CLOCK_MONOTONIC, &time2);
	printf("walked shuffled list in %fs\n",
			diff_time(&time1, &time2));

	clock_gettime(CLOCK_MONOTONIC, &time1);
	walk_array(array);
	clock_gettime(CLOCK_MONOTONIC, &time2);
	printf("walked shuffled array in %fs\n",
			diff_time(&time1, &time2));

	return 0;
}

--MGYHOYXEY6WxJCY8--
