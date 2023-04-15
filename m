Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D45246E31A0
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 15:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbjDONkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 09:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbjDONkj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 09:40:39 -0400
Received: from sender3-op-o19.zoho.com (sender3-op-o19.zoho.com [136.143.184.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AF943A9C
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 06:40:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1681566025; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=LfkX9u3fEF42gg854hOy7/DHpdW9cA1AWZu4ylO/OqvRv79Yn6E7jBH8X2pE+dFD6zIJFGTOa3gbLFG3KrcnXjPYMzdFBOhBlkBNl4ldd2j9kTlBIAT7o8DL70ECeIYxyBbLV/TpCTVwrVIOdnvHpqysnQbRGuhDM9ssWnMLQCc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1681566025; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=XOVbHgjFmCZrqNcw5e3QwVbrTEr0ZWzulxoJY/NCEpo=; 
        b=TfmJlhXZi8VjQ7RWY6Z+TmbSHqtO8Vi2XeJcwfSdDih3K4ctaynndFQCsBwNZNYSrziCZ/4i5LnVpSF1lBQUW7VQmpbY1Gi/YuFehhbc4YxIyaEdC8WThrvsTg85L5ale4eo4fISFOHGNDQXew8r2uaef4kvjAJq63zC9hWWwe0=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1681566025;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=XOVbHgjFmCZrqNcw5e3QwVbrTEr0ZWzulxoJY/NCEpo=;
        b=ibvz/mbxJ3k2RnTEZYffzjiGPHQNYmiE0nQXPsAkWC23K5dhpI2aiL4iZmCVx+Fb
        3RUNlv3ZZV08M549rEUWRDdRxjexyu4WHnUm+zxxmRzVidrne6BvJRd2zzBuI4qTvWp
        3ZsZLsbyDFmYEFJ35p+uk5jXaS6tr8rzD/jQ8Qng=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 1681566023433842.7778622883561; Sat, 15 Apr 2023 06:40:23 -0700 (PDT)
Message-ID: <5f7d58ba-60c8-f635-a06d-a041588f64da@arinc9.com>
Date:   Sat, 15 Apr 2023 16:40:19 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: mt7530: dsa_switch_parse_of() fails, causes probe code to run
 twice
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Daniel Golle <daniel@makrotopia.org>,
        Frank Wunderlich <frank-w@public-files.de>,
        netdev <netdev@vger.kernel.org>, erkin.bozoglu@xeront.com,
        Thibaut <hacks@slashdirt.org>
References: <896514df-af33-6408-8b33-d8fd06e671ef@arinc9.com>
 <ZDnYSVWTUe5NCd1w@makrotopia.org>
 <e10aa146-c307-8a14-3842-ae50ceabf8cc@arinc9.com>
 <ZDnnjcG5uR9gQrUb@makrotopia.org>
 <5e10f823-88f1-053a-d691-6bc900bd85a6@arinc9.com>
 <ZDn1QabUsyZj6J0M@makrotopia.org>
 <01fe9c85-f1e0-107a-6fb7-e643fb76544e@arinc9.com>
 <ZDqb9zrxaZywP5QZ@makrotopia.org>
 <9284c5c0-3295-92a5-eccc-a7b3080f8915@arinc9.com>
 <20230415133813.d4et4oet53ifg2gi@skbuf>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230415133813.d4et4oet53ifg2gi@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15.04.2023 16:38, Vladimir Oltean wrote:
> On Sat, Apr 15, 2023 at 04:19:46PM +0300, Arınç ÜNAL wrote:
>> While speaking here, let's discuss what should be considered probing.
>>
>> One thing that complicates this is that the MT7530 switch has got a unique
>> feature, PHY muxing. I want to be able to use this feature without
>> registering the switch at all. And that requires the switch to be at least
>> reset.
> 
> All DSA switch drivers end their probing with a successful call to
> dsa_register_switch(). I would appreciate if you wouldn't start adding
> exceptions to that.

My wording was not great there. What I meant is that PHY muxing will be 
configured before dsa_register_switch() is run.

Arınç
