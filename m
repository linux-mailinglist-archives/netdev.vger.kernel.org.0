Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08F9D62CC59
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 22:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233074AbiKPVNA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 16:13:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233114AbiKPVM6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 16:12:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2604C3C;
        Wed, 16 Nov 2022 13:12:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F3C6B81EBE;
        Wed, 16 Nov 2022 21:12:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F667C433C1;
        Wed, 16 Nov 2022 21:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668633175;
        bh=vnx9mVfARHSrVJaNSRXAJQNrlYPKT7VsWaOhORiVAsY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TBru58/iEJoBJkVXDPZ4OYBSELb8Zna/f0jpjYlAQH6YR3qTxWTE/rqin+qdqkzRs
         eQzuRHfjwaFRgd8nHdQkoqdNEWchMZIuslNUAvviQrD68iHj3+jwyQutGF0fLdnhE/
         0nq0jEADm/SjpCe5KWYTrA+bRzrQkNv2eQuUTmdEeFohAIAivVP5pvso9TDED+0OE2
         AsXznuFw9dRzl9H9JlT+DkutaLn0NZJTiv6GoeBK6+z7hQ4Daj04UT8Xmho3mbogHj
         nwB1Kxd2nw4ytMj+KSPK19FBFVh/lgWLtNBABuqrdxH5MTmkHg+UvtPW6l0QLuMsNK
         DBwzIXp/EngYg==
Date:   Wed, 16 Nov 2022 13:12:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next 06/11] xdp: Carry over xdp metadata into skb
 context
Message-ID: <20221116131253.6703f1c6@kernel.org>
In-Reply-To: <20221115030210.3159213-7-sdf@google.com>
References: <20221115030210.3159213-1-sdf@google.com>
        <20221115030210.3159213-7-sdf@google.com>
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

On Mon, 14 Nov 2022 19:02:05 -0800 Stanislav Fomichev wrote:
> Implement new bpf_xdp_metadata_export_to_skb kfunc which
> prepares compatible xdp metadata for kernel consumption.
> This kfunc should be called prior to bpf_redirect
> or when XDP_PASS'ing the frame into the kernel (note, the drivers
> have to be updated to enable consuming XDP_PASS'ed metadata).
> 
> veth driver is amended to consume this metadata when converting to skb.
> 
> Internally, XDP_FLAGS_HAS_SKB_METADATA flag is used to indicate
> whether the frame has skb metadata. The metadata is currently
> stored prior to xdp->data_meta. bpf_xdp_adjust_meta refuses
> to work after a call to bpf_xdp_metadata_export_to_skb (can lift
> this requirement later on if needed, we'd have to memmove
> xdp_skb_metadata).

IMO we should split the xdp -> skb work from the pure HW data access 
in XDP. We have a proof point here that there is a way of building 
on top of the first 5 patches to achieve the objective, and that's
sufficient to let the prior work going in.

..because some of us may not agree that we should be pushing in a
fixed-format structure that's also listed in uAPI. And prefer to,
say, let the user define their format and add a call point for a
BPF prog to populate the skb from whatever data they decided to stash...

That's how I interpreted some of John's comments as well, but I may be
wrong.

Either way, there is no technical reason for the xdp -> skb field
propagation to hold up the HW descriptor access, right? If anything 
we may be able to make quicker progress if prior work is in tree
and multiple people can hack...
