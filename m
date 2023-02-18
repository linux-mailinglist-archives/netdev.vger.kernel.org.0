Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E08BB69BB26
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 18:08:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbjBRRIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Feb 2023 12:08:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjBRRIG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Feb 2023 12:08:06 -0500
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3828FEFB4
        for <netdev@vger.kernel.org>; Sat, 18 Feb 2023 09:08:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1676740078; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=izJonpL/6tzuXeTKT0JZNQGJRqkeZMhM14g/6N4QEGGSqgnCiJPad/jy7w9ljMvvlzicvHq5aFrFqyA6alGPbhGrKvPXaowZv5ZhoYq+pd+mF6pNz2OokRVQF4ssbVKWMZQvSEyb2pPwEl3GkSfxMfTMo/F4CECLdhU2v98yp8I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1676740078; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=Zm/Vfv9SYpVrilj4eCxw0OlY6SSXk4IKys52Ljr1ZBM=; 
        b=CTNwrP6ITQ9wdZ0JJJJZQpRBSsKvUI3IdKsQUGafuPXlnNKv7U5lu2xZl5SnzCx8eZpoPFF9nhoEDF3hqr7byMuTzT4RdBB/VXNT7txLwqWD7NEkALl03ey6N6CdapyyTO4IuZXaDxAlYJbjHR6HDxJsic4Y8EjIS22QnDCnoZQ=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1676740078;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:To:To:Cc:Cc:From:From:Subject:Subject:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=Zm/Vfv9SYpVrilj4eCxw0OlY6SSXk4IKys52Ljr1ZBM=;
        b=Urh0FXSzW9PDaqzCOR4WKDYAR57cOp5blFWNgYzIHdR0TRZdOlRDj8HFRxiHFsGC
        gSongQD4GY4ZkF8LBezsTNae/Z7Tmhtp46qKopRiK9BZorLwuCHjmnbYAqo78x3GzFm
        xpXXoRF3Zly/DOQjqZ7ncUO9nJMS0YksmG1MSsxM=
Received: from [10.10.10.3] (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1676740075592980.814037329548; Sat, 18 Feb 2023 09:07:55 -0800 (PST)
Message-ID: <5833a789-fa5a-ce40-f8e5-d91f4969a7c4@arinc9.com>
Date:   Sat, 18 Feb 2023 20:07:53 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>
Cc:     netdev <netdev@vger.kernel.org>, erkin.bozoglu@xeront.com
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Subject: Choose a default DSA CPU port
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey there folks,

The problem is this. Frank and I have got a Bananapi BPI-R2 with MT7623 
SoC. The port5 of MT7530 switch is wired to gmac1 of the SoC. Port6 is 
wired to gmac0. Since DSA sets the first CPU port it finds on the 
devicetree, port5 becomes the CPU port for all DSA slaves.

But we'd prefer port6 since it uses trgmii while port5 uses rgmii. There 
are also some performance issues with the port5 - gmac1 link.

Now we could change it manually on userspace if the DSA subdriver 
supported changing the DSA master.

I'd like to find a solution which would work for the cases of; the 
driver not supporting changing the DSA master, or saving the effort of 
manually changing it on userspace.

The solution that came to my mind:

Introduce a DT property to designate a CPU port as the default CPU port.
If this property exists on a CPU port, that port becomes the CPU port 
for all DSA slaves.
If it doesn't exist, fallback to the first-found-cpu-port method.

Frank doesn't like this idea:

 > maybe define the default cpu in driver which gets picked up by core 
(define port6 as default if available).
 > Imho additional dts-propperty is wrong approch...it should be handled 
by driver. But cpu-port-selection is currently done in dsa-core which 
makes it a bit difficult.

What are your thoughts?

Arınç
