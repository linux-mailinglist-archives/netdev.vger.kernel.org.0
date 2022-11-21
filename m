Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAF55632C45
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 19:47:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbiKUSr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 13:47:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbiKUSrv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 13:47:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B491F13DF0;
        Mon, 21 Nov 2022 10:47:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 543A6B812A1;
        Mon, 21 Nov 2022 18:47:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AFB3C433C1;
        Mon, 21 Nov 2022 18:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669056465;
        bh=2EAmo31DRcbW9roq/lO6oXvVayYGbusj5GgryFsWecM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MLlsidWWufNRyI2lwtmGAwsvcCUK6tVMLpaeklOeeXeEMgw983krUJv/7Av6C4WB4
         s0BZRdRFIUzfolIXifCKCVs/AVeBeSChpCnnBy50WD58jwhwzpAmB+RW7gF9fQeHhO
         tywu/bnO8Te618SZboquJErEpGwZa6jg3yvP+8XCS2xlEeR2MLOj4zPMmB5SWWPvmn
         VZbXLYTCIP/TAymRJ1UbM1d2jNJC+Z8pTfgocITB7bVTJpe+H06CY6SBjmHBUzHWAh
         CLf2+2JzOSg37dbSvWZp8gVKiIatpcJJs//HpSDvWVjREHVDNuXBJlZtIbPuFVbg73
         F2XnYGAN1Szkg==
Date:   Mon, 21 Nov 2022 10:47:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        bpf@vger.kernel.org, brouer@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Subject: Re: [xdp-hints] Re: [PATCH bpf-next 06/11] xdp: Carry over xdp
 metadata into skb context
Message-ID: <20221121104744.10e1afc8@kernel.org>
In-Reply-To: <CAKH8qBtDZo8Mmp=o_fomz97cXNGY6NgOOW8YbJCXx_+_dVf7uw@mail.gmail.com>
References: <20221115030210.3159213-1-sdf@google.com>
        <20221115030210.3159213-7-sdf@google.com>
        <e26f75dd-f52f-a69b-6754-54e1fe044a42@redhat.com>
        <CAKH8qBv8UtHZrgSGzVn3ZJSfkdv1H3kXGbakp9rCFdOABL=3BQ@mail.gmail.com>
        <871qpzxh0n.fsf@toke.dk>
        <CAKH8qBtDZo8Mmp=o_fomz97cXNGY6NgOOW8YbJCXx_+_dVf7uw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Nov 2022 09:53:02 -0800 Stanislav Fomichev wrote:
> > Jakub was objecting to putting it in the UAPI header, but didn't we
> > already agree that this wasn't necessary?
> >
> > I.e., if we just define
> >
> > struct xdp_skb_metadata *bpf_xdp_metadata_export_to_skb()
> >
> > as a kfunc, the xdp_skb_metadata struct won't appear in any UAPI headers
> > and will only be accessible via BTF? And we can put the actual data
> > wherever we choose, since that bit is nicely hidden behind the kfunc,
> > while the returned pointer still allows programs to access it.
> >
> > We could even make that kfunc smart enough that it checks if the field
> > is already populated and just return the pointer to the existing data
> > instead of re-populating it int his case (with a flag to override,
> > maybe?).  
> 
> Even if we only expose it via btf, I think the fact that we still
> expose a somewhat fixed layout is the problem?
> I'm not sure the fact that we're not technically putting in the uapi
> header is the issue here, but maybe I'm wrong?
> Jakub?

Until the device metadata access from BPF is in bpf-next the only
opinion I have on this is something along the lines of "not right now".

I may be missing some concerns / perspectives, in which case - when
is the next "BPF office hours" meeting?
