Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99DB84E45F8
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 19:27:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237418AbiCVS3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 14:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235139AbiCVS3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 14:29:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A733590246;
        Tue, 22 Mar 2022 11:27:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41B12615C0;
        Tue, 22 Mar 2022 18:27:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F171C340EC;
        Tue, 22 Mar 2022 18:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647973651;
        bh=uOSvkHpZ1Gp5Do/Gf5jpgr3xJAKnHMDWMqaC9BanDE0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tFHOHIUA81vi642CvYKLC3JpQKJGfF5h9CyHBiupNSEKY4FQMfOkfHioEtgM3a3G/
         oXcEwHUc0ON2plePihafb4XX3uvuabPt2Khu4fwtsuiJZP5nkbivMwpOERe9cfwvzV
         cjMnZrTz1sL4L1NuieJIVSNY/x3BNtwHFf9FYZac+aDbBuWQgINI9Z7IlCo4hEwZeP
         d0iie3NqlzCN/5xU0bEQahdplhpygP/h5/+y2H3fOrMcOFNwz/11jGsB/sqHDbZfTp
         o3eMNFr1hdEFKOC6zBjjNnwmR//blNXw2Y4OA5QefoP3M63NXyGQPONAcZ5VlHsYih
         eYeYr8tlHRQtA==
Date:   Tue, 22 Mar 2022 11:27:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     'Alexander Lobakin' <alexandr.lobakin@intel.com>,
        'Wan Jiabing' <wanjiabing@vivo.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] ice: use min_t() to make code cleaner in ice_gnss
Message-ID: <20220322112730.482d674d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <af3fa59809654c9b9939f1e0bd8ca76b@AcuMS.aculab.com>
References: <20220321135947.378250-1-wanjiabing@vivo.com>
        <f888e3cf09944f9aa63532c9f59e69fb@AcuMS.aculab.com>
        <20220322175038.2691665-1-alexandr.lobakin@intel.com>
        <af3fa59809654c9b9939f1e0bd8ca76b@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Mar 2022 18:12:08 +0000 David Laight wrote:
> > > Oh FFS why is that u16?
> > > Don't do arithmetic on anything smaller than 'int'  
> > 
> > Any reasoning? I don't say it's good or bad, just want to hear your
> > arguments (disasms, perf and object code measurements) etc.  
> 
> Look at the object code on anything except x86.
> The compiler has to add instruction to mask the value
> (which is in a full sized register) down to 16 bits
> after every arithmetic operation.

Isn't it also slower on some modern x86 CPUs?
I could have sworn someone mentioned that in the past.
