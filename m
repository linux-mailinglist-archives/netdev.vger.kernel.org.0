Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADEE56F261F
	for <lists+netdev@lfdr.de>; Sat, 29 Apr 2023 21:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbjD2Twz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Apr 2023 15:52:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjD2Twy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Apr 2023 15:52:54 -0400
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED5191BD7
        for <netdev@vger.kernel.org>; Sat, 29 Apr 2023 12:52:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1682797953; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=EuQjmWl+Bfl3fbEoISGaXR0XiuLJfKhX/fkfH185V+fC6KPAHYuPcnJ73yh0lv4r8Jrhf/qOqf625EQS6wsOYOZcFJCvpHLuHPeOC1U6s7bvaun65CVxThKGwVdOo3lLfPw+Y6iOiiQgqlztf+tOApQnR1hugxxgKnayDD4e2j4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1682797953; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=3BKf+XARflnWSzDXAy3idQ2rFtjcIpOx8MIFFSxC1ME=; 
        b=fWBTs7soOFUnUqhL/tYfbRRkla/2T6Et5jTQSXgBCxaZsfeSLZ9/RAOQbmUd62Pk7E/l2dyCDsQcFRHxbToi7nWGB039bvMCVWqDMPoK8st4NFRUsPConrJejfmidJRU/2L7yPb54wO2ev+oJwWzjPGy1FezCnHWv7FKEfvyyp4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1682797953;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=3BKf+XARflnWSzDXAy3idQ2rFtjcIpOx8MIFFSxC1ME=;
        b=AeYYIFeiS7AAtUF3su+Oemv/U+1FWxd0OzgDbJ67XD4HXUQO6LvbfAVVikpw+W6E
        e3v2CoKF4wm4nyLWs7cf0AdJY7EEc/H3RXjkZkIJbE9+lE8ykGlgJf84J7ZJqA2oPbK
        FOXcPIj187SaryfW4USIpRb74u5gzHViLRDuLWWQ=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 1682797950677623.4683439058532; Sat, 29 Apr 2023 12:52:30 -0700 (PDT)
Message-ID: <d3a73d34-efd7-2f37-1362-9a2fe5a21592@arinc9.com>
Date:   Sat, 29 Apr 2023 22:52:12 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: MT7530 bug, forward broadcast and unknown frames to the correct
 CPU port
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     DENG Qingfang <dqfext@gmail.com>, Greg Ungerer <gerg@kernel.org>,
        Daniel Golle <daniel@makrotopia.org>,
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        mithat.guner@xeront.com, erkin.bozoglu@xeront.com,
        bartel.eerdekens@constell8.be, netdev <netdev@vger.kernel.org>
References: <20230426205450.kez5m5jr4xch7hql@skbuf>
 <0183eb91-8517-f40f-c2bb-b229e45d6fa5@arinc9.com>
 <8a955c34-5724-af9d-d828-a8786bcc08b0@arinc9.com>
 <8a955c34-5724-af9d-d828-a8786bcc08b0@arinc9.com>
 <20230426205450.kez5m5jr4xch7hql@skbuf>
 <0183eb91-8517-f40f-c2bb-b229e45d6fa5@arinc9.com>
 <8d6a46a7-a769-4532-dd44-f230b705a675@arinc9.com>
 <8d6a46a7-a769-4532-dd44-f230b705a675@arinc9.com>
 <20230429173522.tqd7izelbhr4rvqz@skbuf>
 <680eea9a-e719-bbb1-0c7c-1b843ed2afcd@arinc9.com>
 <20230429185657.jrpcxoqwr5tcyt54@skbuf>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230429185657.jrpcxoqwr5tcyt54@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29.04.2023 21:56, Vladimir Oltean wrote:
> On Sat, Apr 29, 2023 at 09:39:41PM +0300, Arınç ÜNAL wrote:
>> Are you fine with the preferred port patch now that I mentioned port 6
>> would be preferred for MT7531BE since it's got 2.5G whilst port 5 has
>> got 1G? Would you like to submit it or leave it to me to send the diff
>> above and this?
> 
> No, please tell me: what real life difference would it make to a user
> who doesn't care to analyze which CPU port is used?

They would get 2.5 Gbps download/upload bandwidth in total to the CPU, 
instead of 1 Gbps. 3 computers connected to 3 switch ports would each 
get 833 Mbps download/upload speed to/from the CPU instead of 333 Mbps.

Arınç
