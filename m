Return-Path: <netdev+bounces-8978-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D74772674E
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 19:29:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 48DCE28140D
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 17:29:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34FCD37359;
	Wed,  7 Jun 2023 17:29:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE221641B
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 17:29:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B6D4C433D2;
	Wed,  7 Jun 2023 17:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686158985;
	bh=4cpxPwXjsxBXzX3dJe7+qLdXpiRIcHwr0w+H49+sqCc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ZXAEIdofdSk6zcPWE2VcSnn2dYNsddjCss8mLdOGKqjxIZ6Gatm88iZ5SawW5lxeG
	 V/NwEaO6sUhCfe1L8dBg4EVGFeyzgXdlWEsEJMj9X4wsre16eysHL8/0Pw2hlTgSO9
	 KAR0f8w7ZI+gJlHSdXTbYEuLQZyUniJmfCSshVAGLAfXWZHfXMCp0faQ3g2V2Pj+xJ
	 rUMPBVnkzEBPUfdCEm7kg8SqSGfW2Bp1x/Oy9bsf3BkaIAu/In6sVuijfCs3gzmmHh
	 CcTp/FuWgCCxWTPEfMzM0GB2i270VLOB4xfPUjTSXFltX4gpGNoFp+nbl6alyNuIGl
	 znQMylm8on8xA==
Date: Wed, 7 Jun 2023 10:29:44 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: Gal Pressman <gal@nvidia.com>, Edwin Peer <espeer@gmail.com>, David
 Ahern <dsahern@gmail.com>, netdev <netdev@vger.kernel.org>, Andrew
 Gospodarek <andrew.gospodarek@broadcom.com>, Michael Chan
 <michael.chan@broadcom.com>, Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [PATCH net-next 1/4] netlink: truncate overlength attribute
 list in nla_nest_end()
Message-ID: <20230607102944.09bb1216@kernel.org>
In-Reply-To: <20230607095254.20a3394c@hermes.local>
References: <20210123045321.2797360-1-edwin.peer@broadcom.com>
	<20210123045321.2797360-2-edwin.peer@broadcom.com>
	<1dc163b0-d4b0-8f6c-d047-7eae6dc918c4@gmail.com>
	<CAKOOJTwKK5AgTf+g5LS4MMwR_HwbdFS6U7SFH0jZe8FuJMgNgA@mail.gmail.com>
	<CAKOOJTzwdSdwBF=H-h5qJzXaFDiMoX=vjrMi_vKfZoLrkt4=Lg@mail.gmail.com>
	<62a12b2c-c94e-8d89-0e75-f01dc6abbe92@gmail.com>
	<CAKOOJTwBcRJah=tngJH3EaHCCXb6T_ptAV+GMvqX_sZONeKe9w@mail.gmail.com>
	<cdbd5105-973a-2fa0-279b-0d81a1a637b9@nvidia.com>
	<20230605115849.0368b8a7@kernel.org>
	<CAOpCrH4-KgqcmfXdMjpp2PrDtSA4v3q+TCe3C9E5D3Lu-9YQKg@mail.gmail.com>
	<0c04665f-545a-7552-a4c2-c7b9b2ee4e6b@nvidia.com>
	<20230606091706.47d2544d@kernel.org>
	<f2a02c4f-a9c0-a586-1bde-ff2779933270@nvidia.com>
	<20230607093324.2b7712d9@kernel.org>
	<20230607095254.20a3394c@hermes.local>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 7 Jun 2023 09:52:54 -0700 Stephen Hemminger wrote:
> > Hm, you're right. But allocation larger than 32kB are costly.
> > We can't make every link dump allocate 64kB, it will cause
> > regressions on systems under memory pressure (== real world).
> > 
> > You'd need to come up with some careful scheme of using larger
> > buffers.  
> 
> Why does it all have to be a single message?
> Things like 3 million routes are dumped fine, as multiple messages.

The old API we can't change. The new API is switchdev / devlink,
and it's already in place. We'd have to add a third API, like 
the old one but with different msg format which for obvious 
reasons I'd prefer not to do.

