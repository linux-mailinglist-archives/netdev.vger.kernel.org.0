Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5925D6547D7
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 22:26:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbiLVVZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 16:25:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbiLVVZ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 16:25:56 -0500
Received: from mx14lb.world4you.com (mx14lb.world4you.com [81.19.149.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 428BFEE1E
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 13:25:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=C5L2lyICSdwoZ9ESk0JS5o6ks5NIoXo9kWo6CY1cllw=; b=orY8HffauUWDibltvzkhfKFOKn
        RIPi9Edr7JHBzdVSCtrO37wKgJPxhhDMMmfDVETNeUVfNxTKrUtFmcycsAyZtp0WEf8DXE87qsNid
        eg8+EI8JNpxIkQRGSUBykwmg1DGvbZOB78QinG7UvyQA6zAR83yFsFAbdzwPHgqSqBWg=;
Received: from [88.117.53.17] (helo=[10.0.0.160])
        by mx14lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1p8T4Z-0001BD-Ov; Thu, 22 Dec 2022 22:25:51 +0100
Message-ID: <6ca87c55-9cda-294e-43f2-2c9d74b91939@engleder-embedded.com>
Date:   Thu, 22 Dec 2022 22:25:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [RFC PATCH v7] vmxnet3: Add XDP support.
Content-Language: en-US
To:     William Tu <u9012063@gmail.com>, netdev@vger.kernel.org
Cc:     tuc@vmware.com, gyang@vmware.com, doshir@vmware.com
References: <20221222154648.21497-1-u9012063@gmail.com>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <20221222154648.21497-1-u9012063@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22.12.22 16:46, William Tu wrote:
> @@ -1776,6 +1800,7 @@ vmxnet3_rq_cleanup(struct vmxnet3_rx_queue *rq,
>   
>   	rq->comp_ring.gen = VMXNET3_INIT_GEN;
>   	rq->comp_ring.next2proc = 0;
> +	rq->xdp_bpf_prog = NULL;

Reference to BPF program is lost without calling bpf_prog_put(). Are you
sure this is ok? This function is called during ndo_stop too.

[...]

> +static int
> +vmxnet3_xdp_set(struct net_device *netdev, struct netdev_bpf *bpf,
> +		struct netlink_ext_ack *extack)
> +{
> +	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
> +	struct bpf_prog *new_bpf_prog = bpf->prog;
> +	struct bpf_prog *old_bpf_prog;
> +	bool need_update;
> +	bool running;
> +	int err = 0;
> +
> +	if (new_bpf_prog && netdev->mtu > VMXNET3_XDP_MAX_MTU) {
> +		NL_SET_ERR_MSG_MOD(extack, "MTU too large for XDP");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	old_bpf_prog = READ_ONCE(adapter->rx_queue[0].xdp_bpf_prog);

Wouldn't it be simpler if xdp_bpf_prog is move from rx_queue to
adapter?

[...]

> +/* This is the main xdp call used by kernel to set/unset eBPF program. */
> +int
> +vmxnet3_xdp(struct net_device *netdev, struct netdev_bpf *bpf)
> +{
> +	switch (bpf->command) {
> +	case XDP_SETUP_PROG:
> +		netdev_dbg(netdev, "XDP: set program to ");

Did you forget to delete this debug output?

[...]

> +int
> +vmxnet3_xdp_xmit(struct net_device *dev,
> +		 int n, struct xdp_frame **frames, u32 flags)
> +{
> +	struct vmxnet3_adapter *adapter;
> +	struct vmxnet3_tx_queue *tq;
> +	struct netdev_queue *nq;
> +	int i, err, cpu;
> +	int nxmit = 0;
> +	int tq_number;
> +
> +	adapter = netdev_priv(dev);
> +
> +	if (unlikely(test_bit(VMXNET3_STATE_BIT_QUIESCED, &adapter->state)))
> +		return -ENETDOWN;
> +	if (unlikely(test_bit(VMXNET3_STATE_BIT_RESETTING, &adapter->state)))
> +		return -EINVAL;
> +
> +	tq_number = adapter->num_tx_queues;
> +	cpu = smp_processor_id();
> +	tq = &adapter->tx_queue[cpu % tq_number];
> +	if (tq->stopped)
> +		return -ENETDOWN;
> +
> +	nq = netdev_get_tx_queue(adapter->netdev, tq->qid);
> +
> +	__netif_tx_lock(nq, cpu);
> +	for (i = 0; i < n; i++) {
> +		err = vmxnet3_xdp_xmit_frame(adapter, frames[i], tq);
> +		/* vmxnet3_xdp_xmit_frame has copied the data
> +		 * to skb, so we free xdp frame below.
> +		 */
> +		get_page(virt_to_page(frames[i]->data));
> +		xdp_return_frame(frames[i]);
> +		if (err) {
> +			tq->stats.xdp_xmit_err++;
> +			break;
> +		}
> +		nxmit++;

You could just use the loop iterator and drop nxmit. I got this comment
for one of my XDP patches from Saeed Mahameed.

[...]

Did you consider to split this patch into multiple patches to make
review easier?

Gerhard
