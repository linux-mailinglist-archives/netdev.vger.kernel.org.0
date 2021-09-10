Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B04F406D48
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 16:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233804AbhIJOGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 10:06:16 -0400
Received: from kylie.crudebyte.com ([5.189.157.229]:57883 "EHLO
        kylie.crudebyte.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233593AbhIJOGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Sep 2021 10:06:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=V1oXnAODR3aFKsqIo8pbR1DfUUk62/AJPtPWryx7j3A=; b=ex/Bt035mw9RxZAKm2vVO2GyHA
        gIUReped5yrOpFru9jmz5WoaLHBhQ7PxrgQdXSCDFPL0O5BCgB0D3Ss5zeLAUOYyHBE5sMWznnDMv
        rECHEfA6ZaBQWgvSI2Vdtx7xOBTkUMG2kIz4O8WaGKZaR+GgsNJGuKBrjTvGrAtlpCTHwPe/rhqsQ
        fzDywhyN668uWwXN0Ic+3c8rK8hIycu7g4JInX/6EIzdJdYMHnDp4ULn6W8xnCA9q3tJWZVawxbbk
        MkgvAZl1BL3Ab6DMH5xQobINCJbha4L5ktT43j4EuUpBLdLRILPgPM6qEOFSxZNXjmg8szbZKOBNI
        h0ey3DX4KEqkKlTRIOY+r4jL6EEB1lMK+TKXNN34oggc1o0nGXrjD1uP5duE2IJmE76BQIMKzEZ3s
        QSmpmdS+De/f5Z5e7vlfbwIltDYSMV2P2mHIpWdPw5p9XQnC1Gah/n6yehw5WebTNqDRsgNiTKhfS
        2MCZlKqrbq3Gpzlo8PGmXO9dTwR0EVbtWSUVO2EoGAALk+WzixaMbqZLIjFst/XT4q18Lhx25qz+s
        FNwP02kkHK2YiHI7I1EtGy1NQO9BEfddYVrOXCotwsESqMQveg5sNkc14IuFmL5KD5rIoagnG5FWG
        3sZlz7vN5BKn/F2s/YmVhibmSWm9YOwmcl57RYoEw=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Eric Van Hensbergen <ericvh@gmail.com>, Greg Kurz <groug@kaod.org>,
        Latchesar Ionkov <lucho@ionkov.net>, netdev@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net
Subject: Re: [PATCH 2/2] net/9p: increase default msize to 128k
Date:   Fri, 10 Sep 2021 16:04:56 +0200
Message-ID: <6943365.098VrMUqUo@silver>
In-Reply-To: <YTVb3K37JxUWUdXN@codewreck.org>
References: <cover.1630770829.git.linux_oss@crudebyte.com> <CAFkjPTkJFrqhCCHgUBsDiEVjpeJoKZ4gRy=G-4DpJo9xanpYaA@mail.gmail.com> <YTVb3K37JxUWUdXN@codewreck.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sonntag, 5. September 2021 23:48:04 CEST Dominique Martinet wrote:
> Christian Schoenebeck wrote on Sun, Sep 05, 2021 at 03:33:11PM +0200:
> > > Subject: [PATCH] net/9p: increase tcp max msize to 1MB
> >=20
> > Yes, makes sense.
> >=20
> > Is the TCP transport driver of the Linux 9p client somewhat equally mat=
ure
> > to the virtio transport driver? Because I still have macOS support for =
9p
> > in QEMU on my TODO list and accordingly a decision for a specific
> > transport type for macOS will be needed.
>=20
> I'd say it should be just about as stable as virtio.. It's definitely
> getting a lot of tests like syzcaller as it's easy to open an arbitrary
> fd and pass that to kernel for fuzzing.
>=20
> Performance-wise you won't have zero-copy, and the monolitic memory
> blocks requirement is the same, so it won't be as good as virtio but it
> can probably be used. The problem will more be one of setting -- for
> user networking we can always use qemu's networking implementation, but
> for passthrough or tap qemu won't easily be discoverable from the VM,
> I'm not sure about that.
> Does AF_VSOCK work on macos? that could probably easily be added to
> trans_fd...

I haven't looked yet into what the latest options are on macOS. It probably=
=20
takes a while before I'll have time for that, as it is not high priority fo=
r=20
me.

With macOS 11 Apple added many new restrictions of what can still be done=20
beyond user space. For virtualization you would now use the macoOS provided=
=20
hypervisor for instance. Apple sent a bunch of patches last year to support=
=20
their HVF in QEMU.

> > On Samstag, 27. Februar 2021 01:03:40 CEST Dominique Martinet wrote:
> > > Christian Schoenebeck wrote on Fri, Feb 26, 2021 at 02:49:12PM +0100:
> > > > Right now the client uses a hard coded amount of 128 elements. So w=
hat
> > > > about replacing VIRTQUEUE_NUM by a variable which is initialized wi=
th
> > > > a
> > > > value according to the user's requested 'msize' option at init time?
> > > >=20
> > > > According to the virtio specs the max. amount of elements in a
> > > > virtqueue
> > > > is
> > > > 32768. So 32768 * 4k =3D 128M as new upper limit would already be a
> > > > significant improvement and would not require too many changes to t=
he
> > > > client code, right?
> > >=20
> > > The current code inits the chan->sg at probe time (when driver is
> > > loader) and not mount time, and it is currently embedded in the chan
> > > struct, so that would need allocating at mount time (p9_client_create=
 ;
> > > either resizing if required or not sharing) but it doesn't sound too
> > > intrusive yes.
> > >=20
> > > I don't see more adherenences to VIRTQUEUE_NUM that would hurt trying.
> >=20
> > So probably as a first step I would only re-allocate the virtio elements
> > according to the user supplied (i.e. large) 'msize' value if the 9p dri=
ver
> > is not in use at that point, and stick to capping otherwise. That should
> > probably be fine for many users and would avoid need for some
> > synchronization measures and the traps it might bring. But again, I sti=
ll
> > need to read more of the Linux client code first.
>=20
> Right, looking at it again p9_virtio_create would already allow that so
> you just need to pick the most appropriate channel or create a new one
> if required, synchronization shouldn't be too much of a problem.
>=20
> The 9p code is sometimes impressive in its foresight ;)

I just realized this is going to be much more work than I expected. Apparen=
tly=20
struct scatterlist is limited to a value of SG_MAX_SINGLE_ALLOC, which is=20
something around 128 or slightly more:

/*
 * Maximum number of entries that will be allocated in one piece, if
 * a list larger than this is required then chaining will be utilized.
 */
#define SG_MAX_SINGLE_ALLOC		(PAGE_SIZE / sizeof(struct scatterlist))

/*
 * The maximum number of SG segments that we will put inside a
 * scatterlist (unless chaining is used). Should ideally fit inside a
 * single page, to avoid a higher order allocation.  We could define this
 * to SG_MAX_SINGLE_ALLOC to pack correctly at the highest order.  The
 * minimum value is 32
 */
#define SG_CHUNK_SIZE	128

Which explains the current hard coded default value of 128 sglist elements =
in=20
the 9p virtio transport:

#define VIRTQUEUE_NUM	128

So struct virtio_chan would need to switch from scatterlist to a different=
=20
type, probably to sg_table. The latter API allows to automatically chain sg=
=20
lists if the required amount exceeds SG_MAX_SINGLE_ALLOC. It misuses the la=
st=20
sglist element to build a chained list. However chaining is not supported o=
n=20
some architectures:

int __sg_alloc_table(struct sg_table *table, unsigned int nents,
		     unsigned int max_ents, struct scatterlist *first_chunk,
		     unsigned int nents_first_chunk, gfp_t gfp_mask,
		     sg_alloc_fn *alloc_fn)
{
	...
#ifdef CONFIG_ARCH_NO_SG_CHAIN
	if (WARN_ON_ONCE(nents > max_ents))
		return -EINVAL;
#endif
	...
}

So those architectures would still end up with the current 128 sglist eleme=
nts=20
limitation with the 9p virtio transport.

And it is also not clear to me whether the Linux sg_table API allows to gro=
w=20
the table if it had been allocated already; say virtio transport retains th=
e=20
current pre-allocation of hard-coded 128 elements in early p9_virtio_probe(=
)=20
and would then just append more sglists in p9_virtio_create() if needed due=
 to=20
a large msize option provided by user. It "looks" like sg_alloc_table() mig=
ht=20
allow to append, but I am not sure.

Another type candidate would be struct sg_append_table, but its API wants a=
=20
complete list of pages to be provided upon table allocation upfront:

/**
 * sg_alloc_append_table_from_pages - Allocate and initialize an append sg
 *                                    table from an array of pages
 * @sgt_append:  The sg append table to use
 * @pages:       Pointer to an array of page pointers
 * @n_pages:     Number of pages in the pages array
 * @offset:      Offset from start of the first page to the start of a buff=
er
 * @size:        Number of valid bytes in the buffer (after offset)
 * @max_segment: Maximum size of a scatterlist element in bytes
 * @left_pages:  Left pages caller have to set after this call
 * @gfp_mask:	 GFP allocation mask
 *
 * Description:
 *    In the first call it allocate and initialize an sg table from a list =
of
 *    pages, else reuse the scatterlist from sgt_append. Contiguous ranges =
of
 *    the pages are squashed into a single scatterlist entry up to the maxi=
mum
 *    size specified in @max_segment.  A user may provide an offset at a st=
art
 *    and a size of valid data in a buffer specified by the page array. The
 *    returned sg table is released by sg_free_append_table
 *
 * Returns:
 *   0 on success, negative error on failure
 *
 * Notes:
 *   If this function returns non-0 (eg failure), the caller must call
 *   sg_free_append_table() to cleanup any leftover allocations.
 *
 *   In the fist call, sgt_append must by initialized.
 */
int sg_alloc_append_table_from_pages(struct sg_append_table *sgt_append,
		struct page **pages, unsigned int n_pages, unsigned int offset,
		unsigned long size, unsigned int max_segment,
		unsigned int left_pages, gfp_t gfp_mask)
{
	...
}

Which does not really fit here (ATM), as the 9p virtio transport maps the=20
pages on demand apparently, not when the client/transport is created alread=
y.

Either way, additionally functions pack_sg_list() and pack_sg_list_p() in t=
he=20
9p virtio transport would need to be adjusted as well to run like:

	int pack_sg_list() {
		FOR_EACH(sglist in sgtable) {
			for (i in 0..127) {
				... sglist[i] ...
			}
		}
	}

Which is not really a trivial change set. :/

On Montag, 6. September 2021 02:07:56 CEST Dominique Martinet wrote:
> Eric Van Hensbergen wrote on Sun, Sep 05, 2021 at 06:44:13PM -0500:
> > there will likely be a tradeoff with tcp in terms of latency to first
> > message so while
> > absolute bw may be higher processing time may suffer.  8k was default
> > msize
> > to more closely match it to jumbo frames on an ethernet.  of course all
> > that intuition is close to 30 years out of date=E2=80=A6.
>=20
> It's not because the max size is 128k (or 1MB) that this much is sent
> over the wire everytime -- if a message used to fit in 8KB, then its
> on-the-wire size won't change and speed/latency won't be affected for
> these.
>=20
> For messages that do require more than 8KB (read/write/readdir) then you
> can fit more data per message, so for a given userspace request (feed me
> xyz amount of data) you'll have less client-server round-trips, and the
> final user-reflected latency will be better as well -- that's why
> e.g. NFS has been setting a max size of 1MB by default for a while now,
> and they allow even more (32MB iirc? not sure)

I can just speak for the setup case QEMU server <-> virtio <-> Linux client=
=20
now:

In this setup there is definitely no disadvantage regarding latency by rais=
ing=20
msize. It is actually the exact opposite: low msize values significantly=20
increase overall latency, because for each 9p message there is not only the=
=20
latency between each server and client 9p message transfer, but there is al=
so=20
latency added on server side when handling each request, as server has to=20
dispatch between fs driver worker thread(s) and server main thread at least=
=20
twice per 9p request, in some cases even multiple times per request.

That's actually something I'm working on to reduce this to its theoretical=
=20
limit of 2 thread hops for every 9p request type on QEMU server side (WIP).

The only bottleneck situation I can think of when raising msize to a giant=
=20
value is when you have a guest app reading/writing constantly with maximum=
=20
chunk size according to msize (which 'cat' for instance is always doing by=
=20
reading stat's st_blksize). In this case other 9p requests of other threads/
processes would need to wait as that single 9p consumer would occupy all=20
available pages with a single, huge 9p request.

That could be addressed maybe by multiplying msize with the amount of=20
available CPU cores or something like that when allocating the sg table on=
=20
client transport side.

> I've only had done these tests years ago and no longer have access to
> the note that was written back then, but TCP also definitely benefits
> from > 64k msize as long as there's enough memory available.
>=20
> The downside (because it's not free) is there though, you need more
> memory for 9p with big buffers even if we didn't need so much in the
> first place.
> The code using a slab now means that the memory is not locked per mount
> as it used to, but that also means allocations can fail if there is a
> big pressure after not having been released. OTOH as long as it's
> consistently used the buffers will be recycled so it's not necessarily
> too bad performance-wise in hot periods.
>=20
> Ideally we'd need to rework transports to allow scatter-gather (iovec or
> similar API), and work with smaller allocations batched together on
> send, but I don't have time for something like that... If we do that we
> can probably get the best of both worlds -- and could consider >1MB, but
> that's unrealistic as of now, regardless of the transport.

Ok, but that's not an issue for the virtio transport, is it? As virtio=20
transport already uses scatter-gather. AFAICS in case of virtio the issue=20
might be that it's claiming pages on demand instead of pinning them when=20
client/virtio is already created. So it could run out of free pages during=
=20
life time I guess.

Best regards,
Christian Schoenebeck


