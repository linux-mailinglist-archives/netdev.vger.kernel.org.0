Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA8B0647EE8
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 09:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbiLIIGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 03:06:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbiLIIGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 03:06:03 -0500
Received: from mx05lb.world4you.com (mx05lb.world4you.com [81.19.149.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2161D5B589;
        Fri,  9 Dec 2022 00:06:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=2Rga2gHuYVJY9ugAUAlNFXWn/I6xD9IN1m2Si0tekdQ=; b=tOJMRLxLit1QsW6+oo7WK0lP7z
        GQ6HO1tZ51l6TKGz//QtdK4d7L+wc+B0Cc+Ibk2v5PZexrCoMcPReCN5w85N+K/mkrKUA5+dhHWYH
        K7wVYqI0ztdxzCHnhD/5CjCMsskq4VeD2uloXMi6eR032CECX6UvX32jWzC0kkt/6xPQ=;
Received: from [88.117.53.17] (helo=[10.0.0.160])
        by mx05lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1p3YOP-0008D6-JK; Fri, 09 Dec 2022 09:06:01 +0100
Message-ID: <caf29726-c470-7fbb-bbae-56b3a412aa4f@engleder-embedded.com>
Date:   Fri, 9 Dec 2022 09:06:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next v2 3/6] tsnep: Support XDP BPF program setup
Content-Language: en-US
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com
References: <20221208054045.3600-1-gerhard@engleder-embedded.com>
 <20221208054045.3600-4-gerhard@engleder-embedded.com> <Y5KErK9c3Nafn45V@x130>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <Y5KErK9c3Nafn45V@x130>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09.12.22 01:43, Saeed Mahameed wrote:
>> +int tsnep_xdp_setup_prog(struct tsnep_adapter *adapter, struct 
>> bpf_prog *prog,
>> +             struct netlink_ext_ack *extack)
>> +{
>> +    struct net_device *dev = adapter->netdev;
>> +    bool if_running = netif_running(dev);
>> +    struct bpf_prog *old_prog;
>> +
>> +    if (if_running)
>> +        tsnep_netdev_close(dev);
>> +
>> +    old_prog = xchg(&adapter->xdp_prog, prog);
>> +    if (old_prog)
>> +        bpf_prog_put(old_prog);
>> +
>> +    if (if_running)
>> +        tsnep_netdev_open(dev);
> 
> this could fail silently, and then cause double free, when close ndo 
> will be called, the stack won't be aware of the closed state..

I will ensure that no double free will happen when ndo_close is called.

Gerhard
