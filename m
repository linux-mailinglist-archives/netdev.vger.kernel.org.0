Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A140161A028
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 19:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbiKDSjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 14:39:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbiKDSjh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 14:39:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D93CFD37
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 11:39:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA7E0B82F44
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 18:39:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE14C433C1;
        Fri,  4 Nov 2022 18:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667587173;
        bh=/1x8T1Sbcqn2mMSTAmY9BF3BhKFs1opnnC2bU/s2KUI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BVY/sl5N6JYAn1cr+F1Fnlvy7IUvnWA57rdNtsBJOqy7Va8tGcLL3Eg8KcOzkdpUa
         AkJx7BBdLdyE/OTnkJx3oiQkigNs+ptJBOQyMDjEJ1H1AyS3pDwyOgxqzPUMsHJXM/
         e5HJaofx878FeAKZg9lgkx+9mGmLZSexMC8N0peepA9VW7R4HW8qBEC3WPDiZ2pL2L
         LXswDDsPA5uorIkcBwI4FZFEmETFw971ccSlbB7FaRPguekSePvPej9NGyZS49SDS1
         aWtNPwOSYWPAyezSF2j9h8wfJyvt/55nctbhZX+M0GgpF7OEL8nW2yaZj/j9ankVR1
         z61Eiolnj6BGg==
Date:   Fri, 4 Nov 2022 11:39:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nick Child <nnac123@linux.ibm.com>
Cc:     netdev@vger.kernel.org, nick.child@ibm.com, bjking1@linux.ibm.com,
        ricklind@us.ibm.com, dave.taht@gmail.com
Subject: Re: [PATCH v2 net] ibmveth: Reduce maximum tx queues to 8
Message-ID: <20221104113932.3377ebb7@kernel.org>
In-Reply-To: <a2924a54-7e44-952d-8544-d14e44d9d8f5@linux.ibm.com>
References: <20221102183837.157966-1-nnac123@linux.ibm.com>
        <20221103205945.40aacd90@kernel.org>
        <4f84f10b-9a79-17f6-7e2e-f65f0d2934cb@linux.ibm.com>
        <20221104105955.2c3c74a7@kernel.org>
        <a2924a54-7e44-952d-8544-d14e44d9d8f5@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Nov 2022 13:15:39 -0500 Nick Child wrote:
> > Or is the concern coming from your recent work on BQL and having many
> > queues exacerbating buffer bloat?  
> 
> Yes, and Dave can jump in here if I am wrong, but, from my 
> understanding, if the NIC cannot send packets at the rate that
> they are queued then these queues will inevitably fill to txqueuelen.
> In this case, having more queues will not mean better throughput but
> will result in a large number of allocations sitting in queues 
> (bufferbloat). I believe Dave's point was, if more queues does not
> allow for better performance (and can risk bufferbloat) then why
> have so many at all.
> 
> After going through testing and seeing no difference in performance
> with 8 vs 16 queues, I would rather not have the driver be a culprit
> of potential resource hogging.

Right, so my point was that user can always shoot themselves in the
foot with bad configs. You can leave the MAX at 16, in case someone
needs it. Limit the default real queues setting instead, most users
will use the default.
