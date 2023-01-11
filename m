Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 311D8665280
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 04:53:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbjAKDw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 22:52:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbjAKDw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 22:52:56 -0500
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7772AFCDD
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 19:52:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1673409173; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=R8kZvVXuN9fP11Ib6RnFJVaMhc3sQUe19YUcR6us1K7oLPMBaD/jZGkaOVGNUMiBFV5ApjZisMNrXNks+qdbMljaBlWOJ6OnzfOvZgvTSTcDrXQBdcHwOhWWF0YpnVw3OznysUCn8Pgg81gKAFXpKoyarBY48vTA0qow+RmWdHE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1673409173; h=Content-Type:Content-Transfer-Encoding:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=v3AkkuDxxFkR41AuHZlo2tH0Ei+w+p6a8ujMLEGm6Qk=; 
        b=ReqfdHUWYTk/lRIdGggtBeIleJ280M+1PT6NuO5nZ5WyT7wot4nYUAlhB4IVCpsEEX0opRDmJSVwOsS1SxkIOVvSzWCRfAXW21mfDu/3gyIRz7trCxr8+7ak6wpuWt8JRevTCSVxrXE/oPibB/xmuLAlm7wXOzgDsjQRDo+vPt4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=mcqueen.au;
        spf=pass  smtp.mailfrom=craig@mcqueen.au;
        dmarc=pass header.from=<craig@mcqueen.au>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1673409173;
        s=zmail; d=mcqueen.au; i=craig@mcqueen.au;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:From:From:To:To:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
        bh=v3AkkuDxxFkR41AuHZlo2tH0Ei+w+p6a8ujMLEGm6Qk=;
        b=bzD3CJRshDxX7M0lhK1sM7sAxy67tja6wYAGJpmGzhNjBu3E+r6ge1koKECei4xK
        vq+NahW5w13VCCnY8e7P+phptreTxje43U7OU/9+A+hBsZwyLdjq1UAaTUE+RiUnpmS
        VoluKe2QGwABh9tArGyvskxNFwyVOIGkbScVAmJE=
Received: from [172.17.17.238] (159-196-145-163.9fc491.syd.nbn.aussiebb.net [159.196.145.163]) by mx.zohomail.com
        with SMTPS id 1673409172231915.0435362264313; Tue, 10 Jan 2023 19:52:52 -0800 (PST)
Message-ID: <506f2c24-6bad-b378-741f-42c13b079526@mcqueen.au>
Date:   Wed, 11 Jan 2023 14:52:50 +1100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: KSZ8795 incorrect bit definitions for static MAC table
Content-Language: en-US
From:   Craig McQueen <craig@mcqueen.au>
To:     netdev <netdev@vger.kernel.org>
References: <09bf9abc-4a43-f1e9-d5f7-5b034c9812eb@mcqueen.au>
In-Reply-To: <09bf9abc-4a43-f1e9-d5f7-5b034c9812eb@mcqueen.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In my previous message, I said

 > Note that the ksz8863_masks[] change has not been tested, but it 
looks right from a read of the data sheet.

However, I didn't actually include the change for that. Reading the data 
sheets, it looks as though it would need:



diff --git a/drivers/net/dsa/microchip/ksz8795.c 
b/drivers/net/dsa/microchip/ksz8795.c
index 16b546ad0cd3..3c6fee9db038 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -105,8 +105,8 @@ static const u32 ksz8863_masks[] = {
         [STATIC_MAC_TABLE_VALID]        = BIT(19),
         [STATIC_MAC_TABLE_USE_FID_R]    = BIT(21),
         [STATIC_MAC_TABLE_USE_FID_W]    = BIT(21),
-       [STATIC_MAC_TABLE_FID_R]        = GENMASK(29, 26),
-       [STATIC_MAC_TABLE_FID_W]        = GENMASK(29, 26),
+       [STATIC_MAC_TABLE_FID_R]        = GENMASK(25, 22),
+       [STATIC_MAC_TABLE_FID_W]        = GENMASK(25, 22),
         [STATIC_MAC_TABLE_OVERRIDE]     = BIT(20),
         [STATIC_MAC_TABLE_FWD_PORTS]    = GENMASK(18, 16),
         [DYNAMIC_MAC_TABLE_ENTRIES_H]   = GENMASK(5, 0),


