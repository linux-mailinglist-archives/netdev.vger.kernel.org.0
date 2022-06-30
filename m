Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D89245621FA
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 20:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236577AbiF3S1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 14:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236272AbiF3S1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 14:27:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11345427CA
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 11:27:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5BCCB82CA3
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 18:27:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20225C34115;
        Thu, 30 Jun 2022 18:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656613663;
        bh=vZlB4QRdgWqHZDNuidk5DViD5LF3+fh0M8zHRrvX+vI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IBbDCSwRRUEEUh9gT3PZW1hZuVIvz5fC0LHk1yJNa7iHf8iI5cqOe4w81fZ+hT+cA
         QfND6rQWN62H1+5tp7jfoFjQxzFU5FAEzonr/V7ch2FdUOm02LRg7cbN83kCg35vlq
         /Nu8oUmhPTc8mFyO4yyiHB7VU0NhAh1nYaqIahiU6h/ogWix+fNznTlZ+SaM3bePTz
         w1lkAa2mrr2vzxDtOSa1QI/Jb65BjOexsN617xxMwiIkh6w9ZtVP1P97wM920n13TP
         PkWls/drDrgpG/5lSjCHSTnvNgO2nMaWMpi/5SUKDI5NB4WelZbhOPHkUT+drRBhWF
         +YZ/xnEmlDX5g==
Date:   Thu, 30 Jun 2022 11:27:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
        Vadim Fedorenko <vadfed@fb.com>, Aya Levin <ayal@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [RFC PATCH v1 1/3] dpll: Add DPLL framework base functions
Message-ID: <20220630112742.0a1d0bf0@kernel.org>
In-Reply-To: <689711e9-47ca-af2d-b0a7-a6406d9736e1@novek.ru>
References: <20220623005717.31040-1-vfedorenko@novek.ru>
        <20220623005717.31040-2-vfedorenko@novek.ru>
        <DM6PR11MB46579C692B75DEF81530B7339BB59@DM6PR11MB4657.namprd11.prod.outlook.com>
        <34093244-431b-98c8-ba88-82957c659808@novek.ru>
        <DM6PR11MB4657C1830DACC5EB4CD98B789BB49@DM6PR11MB4657.namprd11.prod.outlook.com>
        <a85620a1-94ef-0fdf-3c92-6c9d2e3614f5@novek.ru>
        <DM6PR11MB46572B45C787C6D1351D606C9BBB9@DM6PR11MB4657.namprd11.prod.outlook.com>
        <528be46d-16d4-bf71-a657-8e7fd55f9ebd@novek.ru>
        <20220629192312.45acd2fd@kernel.org>
        <689711e9-47ca-af2d-b0a7-a6406d9736e1@novek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Jun 2022 16:50:46 +0100 Vadim Fedorenko wrote:
> On 30.06.2022 03:23, Jakub Kicinski wrote:
>> On Thu, 30 Jun 2022 00:30:08 +0100 Vadim Fedorenko wrote:  
>>> This way it's getting closer and closer to ptp, but still having phase offset is
>>> fair point and I will go this way. Jakub, do you have any objections?  
>> 
>> How does the DPLL interface interact with PTP? Either API can set the
>> phase.  
> 
> Well, if the same hardware is exposed to both subsystem, it will be serialised 
> by hardware driver. And it goes to hardware implementation on how to deal with 
> such changes. Am I wrong?

That's what ends up happening in practice. But it's a pretty poor
experience for everyone involved :(

Stating the obvious, perhaps, but the goal should be that either the
APIs are disjoint or one is a superset of the other and there can be 
a kernel translation layer so that the driver only has to implement 
one.

By a quick look at the PTP header it has phase offsets for both the
clock and the outputs? Not sure. Don't see much in the docs either.
