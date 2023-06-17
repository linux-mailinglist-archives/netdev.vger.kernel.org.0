Return-Path: <netdev+bounces-11688-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DF78733ED3
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 08:50:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 74F71281866
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 06:50:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F7184C91;
	Sat, 17 Jun 2023 06:50:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DFF92E0EA
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 06:50:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8791CC433C8;
	Sat, 17 Jun 2023 06:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686984643;
	bh=XlwHU8TTy9QSFbYg+lJkhIkmLnnk+oXjdln4Q36CEMA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=jasrSGSODI5yB1vJx2k6oGXOQef2ynh7KIMbupbM1alLi3EgT+qdxbyGFcqEIlpEj
	 koKWJ4WuSj3AV20pw+8DxH+W1eAW+yc9bRiSL7NN/sIQL3lSMI5a6orcrWuuDoxnRk
	 6wM5ddcPUos4CDiybqqDZvoEqApIWsnTMcOyVkcGnLipYD92w3CiuvPvFZGdcxviQi
	 z45SEgzQtZYoqDgi1Nghf1qOLPO/CXhHNsPs00y6K3zI73v+8fnzrzU1be3wmHgDYG
	 ciu5C3YKW+PPlgvCxnRgonBTc0IjU/GEr+593/3Q9VT1C9jqZ3m1fByAnwGRqgt9mn
	 NuF1WtmP9cVrg==
Date: Fri, 16 Jun 2023 23:50:41 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
 netdev@vger.kernel.org, Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
 emil.s.tantilov@intel.com, jesse.brandeburg@intel.com,
 sridhar.samudrala@intel.com, shiraz.saleem@intel.com,
 sindhu.devale@intel.com, willemb@google.com, decot@google.com,
 andrew@lunn.ch, leon@kernel.org, mst@redhat.com, simon.horman@corigine.com,
 shannon.nelson@amd.com, stephen@networkplumber.org, Alan Brady
 <alan.brady@intel.com>, Joshua Hay <joshua.a.hay@intel.com>, Madhu Chittim
 <madhu.chittim@intel.com>, Phani Burra <phani.r.burra@intel.com>,
 Shailendra Bhatnagar <shailendra.bhatnagar@intel.com>
Subject: Re: [PATCH net-next v2 04/15] idpf: add core init and interrupt
 request
Message-ID: <20230616235041.4d3f99fe@kernel.org>
In-Reply-To: <20230614171428.1504179-5-anthony.l.nguyen@intel.com>
References: <20230614171428.1504179-1-anthony.l.nguyen@intel.com>
	<20230614171428.1504179-5-anthony.l.nguyen@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 14 Jun 2023 10:14:17 -0700 Tony Nguyen wrote:
> + * @IDPF_REL_RES_IN_PROG: Resources release in progress

> + * @IDPF_CANCEL_SERVICE_TASK: Do not schedule service task if bit is set
> + * @IDPF_REMOVE_IN_PROG: Driver remove in progress

Why all the X-in-progress flags, again?

> +	set_bit(IDPF_CANCEL_SERVICE_TASK, adapter->flags);
> +	cancel_delayed_work_sync(&adapter->serv_task);
> +	clear_bit(IDPF_CANCEL_SERVICE_TASK, adapter->flags);

Pretty sure workqueue protects from self-requeueing.

