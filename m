Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAA7865F67C
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 23:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235407AbjAEWKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 17:10:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236421AbjAEWJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 17:09:26 -0500
Received: from mx25lb.world4you.com (mx25lb.world4you.com [81.19.149.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 164726E402
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 14:09:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=fIHLMQafWa/PWhPBbx/cxzkEodJZwcP4DA37iHWavhA=; b=BCAMLv+aNu9wzRLBuInSRxVMu5
        2VlIt2frM5pFXxI7UoO+1GSWqnPN9AB6iwF9TQS1QM0Pm3s2jR9MeqzKlNmo0rfZs2eUIlv1mvD7h
        9QrXlHkq9nLJNxUwjze1LF2uc9fYS0NFmriwO5Cc88qOqnwHqiwS37xEI+xIHq4WhPTQ=;
Received: from [88.117.53.17] (helo=[10.0.0.160])
        by mx25lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pDYQ8-0002Di-L3; Thu, 05 Jan 2023 23:09:08 +0100
Message-ID: <b7b122e1-3be9-bee1-ee3d-1b4daa8893ac@engleder-embedded.com>
Date:   Thu, 5 Jan 2023 23:09:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next v3 6/9] tsnep: Support XDP BPF program setup
Content-Language: en-US
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org
References: <20230104194132.24637-1-gerhard@engleder-embedded.com>
 <20230104194132.24637-7-gerhard@engleder-embedded.com>
 <2eaa20bb-2fde-fe6f-5dde-f84bad49a987@intel.com>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <2eaa20bb-2fde-fe6f-5dde-f84bad49a987@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05.01.23 18:24, Alexander Lobakin wrote:
> From: Gerhard Engleder <gerhard@engleder-embedded.com>
> Date: Wed Jan 04 2023 20:41:29 GMT+0100
> 
>> Implement setup of BPF programs for XDP RX path with command
>> XDP_SETUP_PROG of ndo_bpf(). This is prework for XDP RX path support.
>>
>> tsnep_netdev_close() is called directly during BPF program setup. Add
>> netif_carrier_off() and netif_tx_stop_all_queues() calls to signal to
>> network stack that device is down. Otherwise network stack would
>> continue transmitting pakets.
>>
>> Return value of tsnep_netdev_open() is not checked during BPF program
>> setup like in other drivers. Forwarding the return value would result in
>> a bpf_prog_put() call in dev_xdp_install(), which would make removal of
>> BPF program necessary.
>>
>> If tsnep_netdev_open() fails during BPF program setup, then the network
>> stack would call tsnep_netdev_close() anyway. Thus, tsnep_netdev_close()
>> checks now if device is already down.
>>
>> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
>> ---
>>   drivers/net/ethernet/engleder/Makefile     |  2 +-
>>   drivers/net/ethernet/engleder/tsnep.h      | 13 +++++++++++
>>   drivers/net/ethernet/engleder/tsnep_main.c | 25 +++++++++++++++++---
>>   drivers/net/ethernet/engleder/tsnep_xdp.c  | 27 ++++++++++++++++++++++
>>   4 files changed, 63 insertions(+), 4 deletions(-)
>>   create mode 100644 drivers/net/ethernet/engleder/tsnep_xdp.c
>>
>> diff --git a/drivers/net/ethernet/engleder/Makefile b/drivers/net/ethernet/engleder/Makefile
>> index b6e3b16623de..0901801cfcc9 100644
>> --- a/drivers/net/ethernet/engleder/Makefile
>> +++ b/drivers/net/ethernet/engleder/Makefile
>> @@ -6,5 +6,5 @@
>>   obj-$(CONFIG_TSNEP) += tsnep.o
>>   
>>   tsnep-objs := tsnep_main.o tsnep_ethtool.o tsnep_ptp.o tsnep_tc.o \
>> -	      tsnep_rxnfc.o $(tsnep-y)
>> +	      tsnep_rxnfc.o tsnep_xdp.o $(tsnep-y)
> 
> Not related directly to the subject, but could be fixed in that commit I
> hope: you don't need to add $(tsnep-y) to $(tsnep-objs), it gets added
> automatically.

I will fix that with this commit.

>>   tsnep-$(CONFIG_TSNEP_SELFTESTS) += tsnep_selftests.o
>> diff --git a/drivers/net/ethernet/engleder/tsnep.h b/drivers/net/ethernet/engleder/tsnep.h
>> index 29b04127f529..0e7fc36a64e1 100644
>> --- a/drivers/net/ethernet/engleder/tsnep.h
>> +++ b/drivers/net/ethernet/engleder/tsnep.h
> 
> [...]
> 
>> @@ -215,6 +220,14 @@ int tsnep_rxnfc_add_rule(struct tsnep_adapter *adapter,
>>   int tsnep_rxnfc_del_rule(struct tsnep_adapter *adapter,
>>   			 struct ethtool_rxnfc *cmd);
>>   
>> +int tsnep_xdp_setup_prog(struct tsnep_adapter *adapter, struct bpf_prog *prog,
>> +			 struct netlink_ext_ack *extack);
>> +
>> +static inline bool tsnep_xdp_is_enabled(struct tsnep_adapter *adapter)
>> +{
>> +	return !!adapter->xdp_prog;
> 
> Any concurrent access protection? READ_ONCE(), RCU?

I assume this is about prog hotswapping which you mentioned below. Is
concurrent access protection needed without prog hotswapping?

>> +}
>> +
>>   #if IS_ENABLED(CONFIG_TSNEP_SELFTESTS)
>>   int tsnep_ethtool_get_test_count(void);
>>   void tsnep_ethtool_get_test_strings(u8 *data);
> 
> [...]
> 
>> +static int tsnep_netdev_bpf(struct net_device *dev, struct netdev_bpf *bpf)
>> +{
>> +	struct tsnep_adapter *adapter = netdev_priv(dev);
>> +
>> +	switch (bpf->command) {
>> +	case XDP_SETUP_PROG:
>> +		return tsnep_xdp_setup_prog(adapter, bpf->prog, bpf->extack);
>> +	default:
>> +		return -EOPNOTSUPP;
>> +	}
>> +}
> 
> So, after this commit, I'm able to install an XDP prog to an interface,
> but it won't do anything. I think the patch could be moved to the end of
> the series, so that it won't end up with such?

My thinking was to first implement the base and the actual functionality
last. I can move it to the end.

>> +
>>   static int tsnep_netdev_xdp_xmit(struct net_device *dev, int n,
>>   				 struct xdp_frame **xdp, u32 flags)
>>   {
> 
> [...]
> 
>> +int tsnep_xdp_setup_prog(struct tsnep_adapter *adapter, struct bpf_prog *prog,
>> +			 struct netlink_ext_ack *extack)
>> +{
>> +	struct net_device *dev = adapter->netdev;
>> +	bool if_running = netif_running(dev);
>> +	struct bpf_prog *old_prog;
>> +
>> +	if (if_running)
>> +		tsnep_netdev_close(dev);
> 
> You don't need to close the interface if `!prog == !old_prog`. I
> wouldn't introduce redundant down-ups here and leave no possibility for
> prog hotswapping.

If prog hotswapping is possible, then how shall it be ensured that the
old prog is not running anymore before 'bpf_prog_put(old_prog)' is
called? I don't understand how 'READ_ONCE(adapter->xdp_prog)' during RX
path and 'old_prog = xchg(&adapter->xdp_prog, prog)' during prog setup
can ensure that (e.g. in ixgbe driver).

Gerhard
