Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59C874B5524
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 16:48:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243521AbiBNPsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 10:48:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237899AbiBNPsf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 10:48:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5967960A94;
        Mon, 14 Feb 2022 07:48:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E922B61353;
        Mon, 14 Feb 2022 15:48:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE13FC340E9;
        Mon, 14 Feb 2022 15:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644853706;
        bh=Y6wdplViBPfzmR5Zmiwo3N4tSfA5jV8d42GUOXWJqTk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=n4uY9RqHn8elKdaB97sqAJ2DaT1DEIV+0+eWE9d/ZgGRfGViOnNaiGbgUh6w3kxol
         whjtDTHp0ZSnTS9Njz8ZdzZ7BmKSldo1YYEF4sjUFK2uasos/D5xmkTYGdLyHti1Qx
         a5OxZ6hd3e40haVLcL8cIwg8ov/nusbvKtrhvQvaScuHIWkPfqys4DpRzBUeF0OKLy
         wccqARNsvuvPE9nzbmJAY2UzTTzkEdZsqXm0bu5pWy9Bq6DZlnwB7uKAyJAaOd7pli
         JWab3psw81rTYJq04+EQQ4jxu1nJ4hnK/xreO/cSgyujBLTkTcgDL+EsyY6G08tJNn
         HMrhf1zy6LDIg==
Date:   Mon, 14 Feb 2022 07:48:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net, brouer@redhat.com,
        toke@redhat.com, pabeni@redhat.com, echaudro@redhat.com,
        lorenzo.bianconi@redhat.com, toshiaki.makita1@gmail.com,
        andrii@kernel.org
Subject: Re: [PATCH bpf-next 2/3] veth: rework veth_xdp_rcv_skb in order to
 accept non-linear skb
Message-ID: <20220214074824.370d7ae6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YgeUFb4LIP7VfeL9@lore-desk>
References: <cover.1644541123.git.lorenzo@kernel.org>
        <8c5e6e5f06d1ba93139f1b72137f8f010db15808.1644541123.git.lorenzo@kernel.org>
        <20220211170414.7223ff09@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YgeUFb4LIP7VfeL9@lore-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 12 Feb 2022 12:03:49 +0100 Lorenzo Bianconi wrote:
> On Feb 11, Jakub Kicinski wrote:
> > On Fri, 11 Feb 2022 02:20:31 +0100 Lorenzo Bianconi wrote:  
> > > +	if (skb_shared(skb) || skb_head_is_locked(skb)) {  
> > 
> > Is this sufficient to guarantee that the frags can be written?
> > skb_cow_data() tells a different story.  
> 
> Do you mean to consider paged part of the skb always not writable, right?
> In other words, we should check something like:
> 
> 	if (skb_shared(skb) || skb_head_is_locked(skb) ||
> 	    skb_shinfo(skb)->nr_frags) {
> 	    ...
> 	}

Yes, we do have skb_has_shared_frag() but IDK if it guarantees frags
are writable :S
