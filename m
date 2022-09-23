Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91E7B5E8289
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 21:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232629AbiIWTY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 15:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231547AbiIWTY5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 15:24:57 -0400
Received: from mx12lb.world4you.com (mx12lb.world4you.com [81.19.149.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C68275E8;
        Fri, 23 Sep 2022 12:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=llhPC77i/0Uln8EqbjAMexzVdcaaRaoJ9oBfA+9XgUY=; b=Y1AVn107ml5a4qiBybN9OnBDye
        x8o/YOd5rQ3gtgwLTWTnkwUdCfHCnBJmk1rwwK9ThT1cmSnrb2tIYVRsiHS4ch2TGYzd0b1QgdpuE
        LH/QRg2+qb879W1yBkcsxZfkfSDSbD07RVyCGq9I/R6rIybtnIJTJhtclhZ5Zm2eK5eU=;
Received: from [88.117.54.199] (helo=[10.0.0.160])
        by mx12lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1oboI5-0001BU-7U; Fri, 23 Sep 2022 21:24:49 +0200
Message-ID: <39f7776b-e979-1d44-f27c-f9d9ed70dc40@engleder-embedded.com>
Date:   Fri, 23 Sep 2022 21:24:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next 5/7] tsnep: Add EtherType RX flow classification
 support
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, robh+dt@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
References: <20220915203638.42917-1-gerhard@engleder-embedded.com>
 <20220915203638.42917-6-gerhard@engleder-embedded.com>
 <20220921180042.440a8b65@kernel.org>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <20220921180042.440a8b65@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22.09.22 03:00, Jakub Kicinski wrote:
> On Thu, 15 Sep 2022 22:36:35 +0200 Gerhard Engleder wrote:
>> +static int tsnep_add_rule(struct tsnep_adapter *adapter,
>> +			  struct tsnep_rxnfc_rule *rule)
>> +{
>> +	struct tsnep_rxnfc_rule *pred, *cur;
>> +
>> +	tsnep_enable_rule(adapter, rule);
>> +
>> +	pred = NULL;
>> +	list_for_each_entry(cur, &adapter->rxnfc_rules, list) {
>> +		if (cur->location >= rule->location)
>> +			break;
>> +		pred = cur;
>> +	}
>> +
>> +	list_add(&rule->list, pred ? &pred->list : &adapter->rxnfc_rules);
>> +	adapter->rxnfc_count++;
>> +
>> +	return 0;
> 
> This never fails, perhaps the return code is unnecessary

I will simplify as suggested.
