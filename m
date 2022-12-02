Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22D38640D57
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 19:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234459AbiLBSec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 13:34:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234275AbiLBSeb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 13:34:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D27EEC82F
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 10:34:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9DB1A623A6
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 18:34:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3227C433D6;
        Fri,  2 Dec 2022 18:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670006070;
        bh=z0bClPfNJVKux5+60PXOgB5DqG775kJOEdMeu0Ke7+w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jML/wuFEApH3Y/awBeeNwSL7lGmVn4Tkmcl+gE6c8E75gItqf4d8NL249LHs0DbjN
         Wj2mIUIJtmEKyl29QavweT2qi0/UWEGEhQc2RP8VoYjyFa8zJVK8/jkawWOq+DH+DU
         amzrqdRyM/bQQXTHzRs2dS+AKJdOsyBjxg66qud4axAMYq/0cN2iKYpqurxjqc1uju
         bwFyAMybXAXYPYf3D9c93tfQknDlhhLTOEq21JUDLnjNdAM9s76ThbcpD/4kjD5cRx
         nZNRh7tkPyf6yl6Caq41l80cN/x5mDtuVbxJ+WU3OKTSd3KDwRKnz80YWdagCfhwMu
         PXfYGWX2ggWWg==
Date:   Fri, 2 Dec 2022 10:34:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Etienne Champetier <champetier.etienne@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: Multicast packet reordering
Message-ID: <20221202103429.1887d586@kernel.org>
In-Reply-To: <e0f9fb60-b09c-30ad-0670-aa77cc3b2e12@gmail.com>
References: <e0f9fb60-b09c-30ad-0670-aa77cc3b2e12@gmail.com>
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

On Thu, 1 Dec 2022 23:45:53 -0500 Etienne Champetier wrote:
> Using RPS fixes the issue, but to make it short:
> - Is it expect to have multicast packet reordering when just tuning buffer sizes ?
> - Does it make sense to use RPS to fix this issue / anything else / better ?
> - In the case of 2 containers talking using veth + bridge, is it better to keep 1 queue
> and set rps_cpus to all cpus, or some more complex tuning like 1 queue per cpu + rps on 1 cpu only ?

Yes, there are per-cpu queues in various places to help scaling, 
if you don't pin the sender to one CPU and it gets moved you can 
understandably get reordering w/ UDP (both on lo and veth).

As Andrew said that's considered acceptable.
Unfortunately it's one of those cases where we need to relax 
the requirements / stray from the ideal world if we want parallel
processing to not suck..
