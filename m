Return-Path: <netdev+bounces-5506-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 88BA0711EAE
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 06:11:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0C3D51C20F5D
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 04:11:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B88A63D87;
	Fri, 26 May 2023 04:10:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57AFE1FDF;
	Fri, 26 May 2023 04:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0D1A0C433A7;
	Fri, 26 May 2023 04:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685074221;
	bh=JQyCrb/AS2AU8eNQv+rZMtDQP68aB0ijNJNGaDOoPzg=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=FIl7fGndcDdMNTUUBjQ/lxk9ckLrCRUIBlDx3quOHau9ufxJApcUj8W88eIZFB7ow
	 NPV4ejdISGmoGjkF9LzOSCCTD1DNzvOlNLaGPJHAgv22iI5Eu+153JBshgoDraOwj+
	 26yIfSIWsmdNoblJnu+D4wyEOyUBKpQDXYPMXboptdow27omZLy4+TcuKJtobn8EAO
	 31bcAsT+EDqcob6emXWeyzLwkrdjSGfxbcG8PlGWfZELjdd8OIszgA4N9DbwSURSjn
	 PHD3cfMoyzWS4u65abuCoxAtadl/sspFPWIR9Qe+rGa3utWna40RTLLUBctKwYOD9C
	 2ErQTwwp9jODQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E10A5E4F138;
	Fri, 26 May 2023 04:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: stmmac: fix call trace when stmmac_xdp_xmit() is
 invoked
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168507422091.22221.15153316764967144660.git-patchwork-notify@kernel.org>
Date: Fri, 26 May 2023 04:10:20 +0000
References: <20230524125714.357337-1-wei.fang@nxp.com>
In-Reply-To: <20230524125714.357337-1-wei.fang@nxp.com>
To: Wei Fang <wei.fang@nxp.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 peppe.cavallaro@st.com, alexandre.torgue@foss.st.com, joabreu@synopsys.com,
 pabeni@redhat.com, mcoquelin.stm32@gmail.com, ast@kernel.org,
 daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
 sdf@google.com, gerhard@engleder-embedded.com, lorenzo@kernel.org,
 simon.horman@corigine.com, netdev@vger.kernel.org,
 linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 24 May 2023 20:57:14 +0800 you wrote:
> From: Wei Fang <wei.fang@nxp.com>
> 
> We encountered a kernel call trace issue which was related to
> ndo_xdp_xmit callback on our i.MX8MP platform. The reproduce
> steps show as follows.
> 1. The FEC port (eth0) connects to a PC port, and the PC uses
> pktgen_sample03_burst_single_flow.sh to generate packets and
> send these packets to the FEC port. Notice that the script must
> be executed before step 2.
> 2. Run the "./xdp_redirect eth0 eth1" command on i.MX8MP, the
> eth1 interface is the dwmac. Then there will be a call trace
> issue soon. Please see the log for more details.
> The root cause is that the NETDEV_XDP_ACT_NDO_XMIT feature is
> enabled by default, so when the step 2 command is exexcuted
> and packets have already been sent to eth0, the stmmac_xdp_xmit()
> starts running before the stmmac_xdp_set_prog() finishes. To
> resolve this issue, we disable the NETDEV_XDP_ACT_NDO_XMIT
> feature by default and turn on/off this feature when the bpf
> program is installed/uninstalled which just like the other
> ethernet drivers.
> 
> [...]

Here is the summary with links:
  - [net] net: stmmac: fix call trace when stmmac_xdp_xmit() is invoked
    https://git.kernel.org/netdev/net/c/ffb3322181d9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



