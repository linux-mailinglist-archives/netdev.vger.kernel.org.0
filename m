Return-Path: <netdev+bounces-9782-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C77D472A8DC
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 05:47:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7AF3C281ACA
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 03:47:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBA071FCA;
	Sat, 10 Jun 2023 03:47:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7F217C1
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 03:47:37 +0000 (UTC)
Received: from mail-m11875.qiye.163.com (mail-m11875.qiye.163.com [115.236.118.75])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69A83272A;
	Fri,  9 Jun 2023 20:47:34 -0700 (PDT)
Received: from [IPV6:240e:3b7:3279:1440:9db:41ed:be98:62d0] (unknown [IPV6:240e:3b7:3279:1440:9db:41ed:be98:62d0])
	by mail-m11875.qiye.163.com (Hmail) with ESMTPA id 9DE07280E6E;
	Sat, 10 Jun 2023 11:47:27 +0800 (CST)
Message-ID: <ffa3498a-4227-837c-b7b8-e00f4b327a80@sangfor.com.cn>
Date: Sat, 10 Jun 2023 11:47:40 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH net-next] net: ethtool: Fix out-of-bounds copy to user
To: Alexander Duyck <alexander.duyck@gmail.com>,
 Jakub Kicinski <kuba@kernel.org>
Cc: Andrew Lunn <andrew@lunn.ch>, davem@davemloft.net, edumazet@google.com,
 pabeni@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 pengdonglin@sangfor.com.cn, huangcun@sangfor.com.cn
References: <20230601112839.13799-1-dinghui@sangfor.com.cn>
 <6110cf9f-c10e-4b9b-934d-8d202b7f5794@lunn.ch>
 <f7e23fe6-4d30-ef1b-a431-3ef6ec6f77ba@sangfor.com.cn>
 <6e28cea9-d615-449d-9c68-aa155efc8444@lunn.ch>
 <CAKgT0UdyykQL-BidjaNpjX99FwJTxET51U29q4_CDqmABUuVbw@mail.gmail.com>
 <ece228a3-5c31-4390-b6ba-ec3f2b6c5dcb@lunn.ch>
 <CAKgT0Uf+XaKCFgBRTn-viVsKkNE7piAuDpht=efixsAV=3JdFQ@mail.gmail.com>
 <44905acd-3ac4-cfe5-5e91-d182c1959407@sangfor.com.cn>
 <20230602225519.66c2c987@kernel.org>
 <5f0f2bab-ae36-8b13-2c6d-c69c6ff4a43f@sangfor.com.cn>
 <20230604104718.4bf45faf@kernel.org>
 <f6ad6281-df30-93cf-d057-5841b8c1e2e6@sangfor.com.cn>
 <20230605113915.4258af7f@kernel.org>
 <034f5393-e519-1e8d-af76-ae29677a1bf5@sangfor.com.cn>
 <CAKgT0UdX7cc-LVFowFrY7mSZMvN0xc+w+oH16GNrduLY-AddSA@mail.gmail.com>
 <9c1fecc1-7d17-c039-6bfa-c63be6fcf013@sangfor.com.cn>
 <20230609101301.39fcb12b@kernel.org>
 <CAKgT0UeePd_+UwpGTT_v7nacf=yLoravtEZ2-gN4dpeWC5AsBg@mail.gmail.com>
From: Ding Hui <dinghui@sangfor.com.cn>
In-Reply-To: <CAKgT0UeePd_+UwpGTT_v7nacf=yLoravtEZ2-gN4dpeWC5AsBg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVkaSUxNVk0eTBhJQ0tKGk1CGFUTARMWGhIXJBQOD1
	lXWRgSC1lBWUlPSx5BSBlMQUhJTEJBSk9PS0FCHxlBT0oeH0EZHkJDQU1JH0tZV1kWGg8SFR0UWU
	FZT0tIVUpKS0hKTFVKS0tVS1kG
X-HM-Tid: 0a88a36a888b2eb1kusn9de07280e6e
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Nk06LAw5HT1DTSM3MC0rMUoe
	EBUwCyJVSlVKTUNNSE1DQ09DT0tDVTMWGhIXVR8SFRwTDhI7CBoVHB0UCVUYFBZVGBVFWVdZEgtZ
	QVlJT0seQUgZTEFISUxCQUpPT0tBQh8ZQU9KHh9BGR5CQ0FNSR9LWVdZCAFZQU9IQ043Bg++
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/6/10 1:59, Alexander Duyck wrote:
> On Fri, Jun 9, 2023 at 10:13 AM Jakub Kicinski <kuba@kernel.org> wrote:
>>
>> On Fri, 9 Jun 2023 23:25:34 +0800 Ding Hui wrote:
>>> drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c: .get_sset_count         = nfp_net_get_sset_count,
>>> drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c: .get_sset_count         = nfp_port_get_sset_count,
>>
>> Not sure if your research is accurate, NFP does not change the number
>> of stats. The number depends on the device and the FW loaded, but those
>> are constant during a lifetime of a netdevice.

Sorry, my research is rough indeed.

> 
> Yeah, the value doesn't need to be a constant, it just need to be constant.
> 
> So for example in the ixgbe driver I believe we were using the upper
> limits on the Tx and Rx queues which last I recall are stored in the
> netdev itself.
> 
Thanks to point that, the examples NFP and ixgbe do help me.
            
-- 
Thanks,
-dinghui


