Return-Path: <netdev+bounces-1006-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 27E556FBCD9
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 04:05:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4D4A01C20A9E
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 02:05:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B71238D;
	Tue,  9 May 2023 02:05:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E940E7C
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 02:05:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F813C433D2;
	Tue,  9 May 2023 02:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683597916;
	bh=MCFBEqGi1KKk85wrI+ztcr/sj/9k0pJky3yc4eIIItc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=IQYiuwSckwRL/o0Vm1wTGmRzPIMjG1hLfNlMZz8WV0vL3Czu7OlNTH/TinLWwLS8G
	 4sHElsx5zZgU8bh/KgaokqzqlbK0Vhj328c3gI5ew0tpWGyIMPHX4UnwkvS9ThZjld
	 ICy6Jf18lRcvA5p1Qfa0ETeOL7wiy4To/N3tud/0CXrTMDDZdqHQ4UR1N8fAOJJL9b
	 GGwUCSMZ3YySPwrdGaJUJRAGq90fDl7MpA3q+k/4rJffSUbXBBlk3zcaMVupays/y+
	 pplpVhDeWuOFlnaKZPi53aTrBnA1j9I87dNmaIIfPwHjEn8TKw92XEF4ihQkXsDxIa
	 y+baFwUGXyNPQ==
Date: Mon, 8 May 2023 19:05:15 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Cathy Zhang <cathy.zhang@intel.com>
Cc: edumazet@google.com, davem@davemloft.net, pabeni@redhat.com,
 jesse.brandeburg@intel.com, suresh.srinivas@intel.com,
 tim.c.chen@intel.com, lizhen.you@intel.com, eric.dumazet@gmail.com,
 netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: Add sysctl_reclaim_threshold
Message-ID: <20230508190515.60f090c7@kernel.org>
In-Reply-To: <20230508020801.10702-3-cathy.zhang@intel.com>
References: <20230508020801.10702-1-cathy.zhang@intel.com>
	<20230508020801.10702-3-cathy.zhang@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun,  7 May 2023 19:08:01 -0700 Cathy Zhang wrote:
> Add a new ABI /proc/sys/net/core/reclaim_threshold which allows to
> change the size of reserved memory from reclaiming in sk_mem_uncharge.
> It allows to keep sk->sk_forward_alloc as small as possible when
> system is under memory pressure, it also allows to change it larger to
> avoid memcg charge overhead and improve performance when system is not
> under memory pressure. The original reclaim threshold for reserved
> memory per-socket is 2MB, it's selected as the max value, while the
> default value is 64KB which is closer to the maximum size of sk_buff.
> 
> Issue the following command as root to change the default value:
> 
> 	echo 16384 > /proc/sys/net/core/reclaim_threshold

While we wait for Eric to pass judgment - FWIW to me it seems a bit
overzealous to let users tune this. Does cgroup memory accounting
or any other socket memory accounting let users control the batching
parameters?

