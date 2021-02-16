Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAA0731C5AF
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 03:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbhBPCxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 21:53:20 -0500
Received: from mga17.intel.com ([192.55.52.151]:28286 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229652AbhBPCxT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 21:53:19 -0500
IronPort-SDR: SQyMQ7JaYaEiyhF7cZ6EZb81uTj0v9oOInDeoj7qzP5IF9nE2kEF+CJbmCA+t/X+lyQDe4V+ns
 Oa4yYPWwcDNA==
X-IronPort-AV: E=McAfee;i="6000,8403,9896"; a="162562716"
X-IronPort-AV: E=Sophos;i="5.81,182,1610438400"; 
   d="scan'208";a="162562716"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2021 18:52:36 -0800
IronPort-SDR: vROyxlKgbqyxckGwLiEu3q4lut2kRAwBk6T++u8kzNsAoo3NavCvlqkc+gc18srDYTZ1B/ifh3
 1jjg1HDUk6tw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,182,1610438400"; 
   d="scan'208";a="426123169"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga002.fm.intel.com with ESMTP; 15 Feb 2021 18:52:33 -0800
Date:   Tue, 16 Feb 2021 03:42:44 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     daniel@iogearbox.net, ast@kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, andrii@kernel.org, toke@redhat.com,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        ciara.loftus@intel.com
Subject: Re: [PATCH bpf-next 2/3] libbpf: clear map_info before each
 bpf_obj_get_info_by_fd
Message-ID: <20210216024244.GE9572@ranger.igk.intel.com>
References: <20210215154638.4627-1-maciej.fijalkowski@intel.com>
 <20210215154638.4627-3-maciej.fijalkowski@intel.com>
 <602adaa11468c_3ed41208c5@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <602adaa11468c_3ed41208c5@john-XPS-13-9370.notmuch>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 15, 2021 at 12:33:37PM -0800, John Fastabend wrote:
> Maciej Fijalkowski wrote:
> > xsk_lookup_bpf_maps, based on prog_fd, looks whether current prog has a
> > reference to XSKMAP. BPF prog can include insns that work on various BPF
> > maps and this is covered by iterating through map_ids.
> > 
> > The bpf_map_info that is passed to bpf_obj_get_info_by_fd for filling
> > needs to be cleared at each iteration, so that it doesn't any outdated
> > fields and that is currently missing in the function of interest.
> > 
> > To fix that, zero-init map_info via memset before each
> > bpf_obj_get_info_by_fd call.
> > 
> > Also, since the area of this code is touched, in general strcmp is
> > considered harmful, so let's convert it to strncmp and provide the
> > length of the array name that we're looking for.
> > 
> > Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > ---
> 
> This is a bugfix independent of the link bits correct? Would be best
> to send to bpf then. 

Right, I can pull this out of the series.

> 
> >  tools/lib/bpf/xsk.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> > index 5911868efa43..fb259c0bba93 100644
> > --- a/tools/lib/bpf/xsk.c
> > +++ b/tools/lib/bpf/xsk.c
> > @@ -616,6 +616,7 @@ static int xsk_lookup_bpf_maps(struct xsk_socket *xsk)
> >  	__u32 i, *map_ids, num_maps, prog_len = sizeof(struct bpf_prog_info);
> >  	__u32 map_len = sizeof(struct bpf_map_info);
> >  	struct bpf_prog_info prog_info = {};
> > +	const char *map_name = "xsks_map";
> >  	struct xsk_ctx *ctx = xsk->ctx;
> >  	struct bpf_map_info map_info;
> >  	int fd, err;
> > @@ -645,13 +646,14 @@ static int xsk_lookup_bpf_maps(struct xsk_socket *xsk)
> >  		if (fd < 0)
> >  			continue;
> >  
> > +		memset(&map_info, 0, map_len);
> >  		err = bpf_obj_get_info_by_fd(fd, &map_info, &map_len);
> >  		if (err) {
> >  			close(fd);
> >  			continue;
> >  		}
> >  
> > -		if (!strcmp(map_info.name, "xsks_map")) {
> > +		if (!strncmp(map_info.name, map_name, strlen(map_name))) {
> >  			ctx->xsks_map_fd = fd;
> >  			continue;
> 
> Also just looking at this how is above not buggy? Should be a break instead
> of continue? If we match another "xsks_map" here won't we stomp on xsks_map_fd
> and leak a file descriptor?

Will fix!

> 
> >  		}
> > -- 
> > 2.20.1
> > 
> 
> 
