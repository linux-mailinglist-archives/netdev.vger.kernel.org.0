Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C823051CDA1
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 02:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387410AbiEFANq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 20:13:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353543AbiEFANo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 20:13:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A643D506CC;
        Thu,  5 May 2022 17:10:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3682261FC6;
        Fri,  6 May 2022 00:10:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A6B9C385A4;
        Fri,  6 May 2022 00:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651795802;
        bh=SkW1gvna9Jui2+It6Mco0C/AQsEKhZD48eOJilj0TN0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QpcWJyqokb21XPQGjuEgHSCCNGmYFCVQnwgBauXHPtvNuU2AAlyUPEyvmeFowjDDH
         KBeegr1lZ1mMOFORbwzFYUmbVSmhAJNGs+SVATHlQKD2iED3Qh4/0jNsIwN77KVtAb
         GAwGntL0bA/Ay9b9e15uTFMwNmLhJmm9orRllnd4r8L++Mq1Ab2ZWKqyPllB9ic0Jk
         B+R9z7kprrsUim/f3y2FQMN1/KPDzjLXFsJVJ4EdSwHLqDEDSWUY6qh4owWCPUKfVr
         V7ls6tjTWd6jBuMbPwHnONnXVeu1eLIFBJL37cMOaEVV5wsFhLy+CArlc2MgC6Sk7s
         sCC6Dkz6Ta1VA==
Date:   Thu, 5 May 2022 17:10:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        linux-crypto@vger.kernel.org, io-uring@vger.kernel.org,
        kernel@pengutronix.de,
        Horia =?UTF-8?B?R2VhbnTEgw==?= <horia.geanta@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org
Subject: Re: [BUG] Layerscape CAAM+kTLS+io_uring
Message-ID: <20220505171000.48a9155b@kernel.org>
In-Reply-To: <20220505192046.hczmzg7k6tz2rjv3@pengutronix.de>
References: <878rrqrgaj.fsf@pengutronix.de>
        <20220505192046.hczmzg7k6tz2rjv3@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 May 2022 21:20:46 +0200 Marc Kleine-Budde wrote:
> Hello,
> 
> no one seems to care about this problem. :/
> 
> Maybe too many components are involved, I'm the respective maintainers
> on Cc.
> 
> Cc += the CAAM maintainers
> Cc += the io_uring maintainers
> Cc += the kTLS maintainers
> 
> On 27.04.2022 10:20:40, Steffen Trumtrar wrote:
> > Hi all,
> > 
> > I have a Layerscape-1046a based board where I'm trying to use a
> > combination of liburing (v2.0) with splice, kTLS and CAAM (kernel
> > v5.17). The problem I see is that on shutdown the last bytes are
> > missing. It looks like io_uring is not waiting for all completions
> > from the CAAM driver.
> > 
> > With ARM-ASM instead of the CAAM, the setup works fine.  
> 
> What's the difference between the CAAM and ARM-ASM crypto? Without
> looking into the code I think the CAAM is asynchron while ARM-ASM is
> synchron. Is this worth investigating?

Sounds like
20ffc7adf53a ("net/tls: missing received data after fast remote close")
