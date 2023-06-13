Return-Path: <netdev+bounces-10556-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 33C7272F040
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 01:41:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E294E2812E9
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 23:41:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A2933EDAE;
	Tue, 13 Jun 2023 23:41:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914101361
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 23:41:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E30E7C433C0;
	Tue, 13 Jun 2023 23:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686699670;
	bh=QkHLW0+bF/8Mht7PyX3mtYgQ+yPUPt7SIGQQFtVIFA4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mUd8+xXUDE26axlldp+QHoDh1LlSwRrvTye3U9EKqA1L0rT68/eE/KHVsdt9aj88o
	 1xuva0h3DkfGaS+5eGpyTOK7W9osM03MM+ujSJnPMCppWv0jsIlf8B1u7q0rkN0F/H
	 2iocMYbgoUvvKk1jzoDuYnbzzsycnuPT0hD/ZB6UTtPgIMPiFZeyPmznl8LIOA5fvZ
	 NEIotuiPWTxV5SLeUqnOBbHc8gGryGYi7Gcn+RqmsCZMq+LMBEo1eEwdZ+vfe7X5MD
	 YLGb322Qoz4rWEM/5Zk8M+7WefDSzBgNRc//FvtYPcDlArrmMunKmo9DNQCvb9HQZO
	 bQYuqUUIgYN1g==
Date: Tue, 13 Jun 2023 16:41:08 -0700
From: Saeed Mahameed <saeed@kernel.org>
To: "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>,
	netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
	Shay Drory <shayd@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>
Subject: Re: [net-next 14/15] net/mlx5: Light probe local SFs
Message-ID: <ZIj+lATlZBSAc5kh@x130>
References: <20230610014254.343576-1-saeed@kernel.org>
 <20230610014254.343576-15-saeed@kernel.org>
 <20230610000123.04c3a32f@kernel.org>
 <ZIVKfT97Ua0Xo93M@x130>
 <c8ac5a24-3ade-d8a8-5135-c3aac57a5f54@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c8ac5a24-3ade-d8a8-5135-c3aac57a5f54@intel.com>

On 10 Jun 22:10, Samudrala, Sridhar wrote:
>
>
>On 6/10/2023 9:15 PM, Saeed Mahameed wrote:
>>On 10 Jun 00:01, Jakub Kicinski wrote:
>>>On Fri,  9 Jun 2023 18:42:53 -0700 Saeed Mahameed wrote:
>>>>In case user wants to configure the SFs, for example: to use only vdpa
>>>>functionality, he needs to fully probe a SF, configure what he wants,
>>>>and afterward reload the SF.
>>>>
>>>>In order to save the time of the reload, local SFs will probe without
>>>>any auxiliary sub-device, so that the SFs can be configured prior to
>>>>its full probe.
>>>
>>>I feel like we talked about this at least twice already, and I keep
>>>saying that the features should be specified when the device is
>>>spawned. Am I misremembering?
>>>
>>
>>I think we did talk about this, but after internal research we prefer to
>>avoid adding additional knobs, unless you insist :) .. I think we 
>>already did a research and we feel that all of our users are
>>going to re-configure the SF anyway, so why not make all SFs start with
>>"blank state" ?
>
>Shouldn't this be a devlink port param to enable/disable a specific 
>feature on the SF before it is activated rather than making it a dev 
>param on the SF aux device and requiring a devlink reload?
>

Specific virtual HCA/SF/VF features are not directly related to what aux
devices to expose, this is a separate feature that we are currently
working on.

We are going to add devlink port params to have a granular control of what
features the SF/VF will expose, e.g ipsec, tls, etc ..  

These would affect the internal characteristic of the aux ULPs (netdev,
rdma,vdpa) .. 

But in this series, we improve the orchestration process of SF and what aux
devs would spawn with it by default.. we already have an API to
enable/disable what aux devs an SF would have, here we just improve the
sequence of creating the SF.

>>
>>>Will this patch not surprise existing users? You're changing the
>>
>>I think we already checked, the feature is still not widely known.
>>Let me double check.
>>
>>>defaults. Does "local" mean on the IPU? Also "lightweight" feels
>>>uncomfortably close to marketing language.
>>>
>>
>>That wasn't out intention, poor choice of words, will reword to "blank SF"
>>
>>>>The defaults of the enable_* devlink params of these SFs are set to
>>>>false.
>>>>
>>>>Usage example:
>>>
>>>Is this a real example? Because we have..
>>>
>>>>Create SF:
>>>>$ devlink port add pci/0000:08:00.0 flavour pcisf pfnum 0 sfnum 11
>>>
>>>sfnum 11 here
>>>
>>
>>This an arbitrary user index.
>>
>>>>$ devlink port function set pci/0000:08:00.0/32768 \
>>>
>>>then port is 32768
>>>
>>
>>This is the actual HW port index, our SFs indexing start with an offset.
>>
>>>>               hw_addr 00:00:00:00:00:11 state active
>>>>
>>>>Enable ETH auxiliary device:
>>>>$ devlink dev param set auxiliary/mlx5_core.sf.1 \
>>>
>>>and instance is sf.1
>>>
>>
>>This was the first SF aux dev to be created on the system. :/
>>
>>It's a mess ha...
>>
>>Maybe we need to set the SF aux device index the same as the user index.
>>But the HW/port index will always be different, otherwise we will 
>>need a map
>>inside the driver.
>
>Yes. Associating sfnum passed by user when creating a SF with the aux 
>device would make it easier for orchestration tools to identify the 
>aux device corresponding to a SF.
>


