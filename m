Return-Path: <netdev+bounces-7541-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 929B072095C
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 20:46:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CA9561C211EE
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 18:46:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D2B71C745;
	Fri,  2 Jun 2023 18:46:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0478117759
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 18:46:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60E33C433EF;
	Fri,  2 Jun 2023 18:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685731592;
	bh=HFvy818AUZOv8tnX8tGWKMTckvvzEudDl32yOi/rGqc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qu/5K32PHF+cHUdMpsddkUZfY4x6BkI0FVmN1cmqlJLgDRN35/iiROztYWtJ8JBxE
	 tamsrJ+3IAlvyolUP/+Mql+ETDSyR8+gDBxAAoUDiExHssMVP0R3H8pu65d3sgcZ9S
	 eUMkqs4PQgLhHYK02cKBVtjE5xAlm6tn835WaM4Ug41WQHSZ9r6zkNPiremmUcBi+q
	 3+VLfGgHa7NyNYb22/S7a6OBLD88Cn/Zny6N0XALtILLMiixzeP0tHYncRaFQV50VR
	 +lztWPX8Y9hrSMu0cmDKW4ShWf6lGyBptlSgmBOpZN8/TWQlo0QQi5wKQr8VgKRmI7
	 v9mz+l2aRxLtw==
Date: Fri, 2 Jun 2023 11:46:31 -0700
From: Saeed Mahameed <saeed@kernel.org>
To: Simon Horman <simon.horman@corigine.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
	Shay Drory <shayd@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: Re: [net-next 03/14] net/mlx5e: rep, store send to vport rules per
 peer
Message-ID: <ZHo5B9vhM5juCxWv@x130>
References: <20230601060118.154015-1-saeed@kernel.org>
 <20230601060118.154015-4-saeed@kernel.org>
 <ZHoSlnSX0K4xeZOF@corigine.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <ZHoSlnSX0K4xeZOF@corigine.com>

On 02 Jun 18:02, Simon Horman wrote:
>On Wed, May 31, 2023 at 11:01:07PM -0700, Saeed Mahameed wrote:
>> From: Mark Bloch <mbloch@nvidia.com>
>>
>> Each representor, for each send queue, is holding a
>> send_to_vport rule for the peer eswitch.
>>
>> In order to support more than one peer, and to map between the peer
>> rules and peer eswitches, refactor representor to hold both the peer
>> rules and pointer to the peer eswitches.
>> This enables mlx5 to store send_to_vport rules per peer, where each
>> peer have dedicate index via mlx5_get_dev_index().
>>
>> Signed-off-by: Mark Bloch <mbloch@nvidia.com>
>> Signed-off-by: Shay Drory <shayd@nvidia.com>
>> Reviewed-by: Roi Dayan <roid@nvidia.com>
>> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
>
>...
>
>> @@ -426,15 +437,24 @@ static int mlx5e_sqs2vport_start(struct mlx5_eswitch *esw,
>>  		rep_sq->sqn = sqns_array[i];
>>
>>  		if (peer_esw) {
>> +			int peer_rule_idx = mlx5_get_dev_index(peer_esw->dev);
>> +
>> +			sq_peer = kzalloc(sizeof(*sq_peer), GFP_KERNEL);
>> +			if (!sq_peer)
>> +				goto out_sq_peer_err;
>
>Hi Mark and Saeed,
>
>Jumping to out_sq_peer_err will return err.
>But err seems to be uninitialised here.
>

Thanks Simon, They change this logic in a later refactoring patch:
"net/mlx5: Devcom, introduce devcom_for_each_peer_entry" 
where this issue doesn't exist anymore, but i will fix anyway..

Thanks,
Saeed.


