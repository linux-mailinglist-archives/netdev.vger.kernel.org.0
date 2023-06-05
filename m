Return-Path: <netdev+bounces-8019-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C57257226DC
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 15:06:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 80269281290
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 13:06:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6F8219904;
	Mon,  5 Jun 2023 13:06:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F566ABC
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 13:06:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AA45C433D2;
	Mon,  5 Jun 2023 13:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685970379;
	bh=EGNBHcb8bMaX7EnPk8wnvORybQqzdd6cyxGABhUCLFg=;
	h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
	b=CmAN0YwISMOzeOVJijaEgbWY/JMfyepDthL3+4a+LfuhNPLBiqEXgePlTr3WBde0C
	 SG3DF9mVjc+ZzjS7toNqoqsBgxYJl7d45auDHXeStx4G/X+x0i8VVk1VFohHRSX8AO
	 NORAg8Xxbp4sDhg2fpjfjwCqDBrAFAwbYn9DNNKDUAEVoE3lpY+lPkC2fNOLjOW4Xv
	 B8fEBbSsRtFlfIyPfyYAEYhcUB7PPNgJbUZPgsuZOjJpRHJopcBbyn2JDZkCAwY9Po
	 4rFKISrIrrH9uLXu2Sz2Al+4FQYx3PCZQzDkYLhG5UOPHhi1XfaRyYxg0PDy9TpKxY
	 ojd6Gt3qhigiQ==
From: Kalle Valo <kvalo@kernel.org>
To: "Arnd Bergmann" <arnd@kernel.org>
Cc: Netdev <netdev@vger.kernel.org>,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wireless: ath: work around false-positive stringop-overread warning
References: <20230417205447.1800912-1-arnd@kernel.org>
	<87ttwnnrer.fsf@kernel.org>
	<504c5a7d-0bfd-4b1e-a7f0-65d072657e0a@app.fastmail.com>
	<87mt2eoopo.fsf@kernel.org>
	<c7f88295-2e22-4100-b9c8-feb380b64359@app.fastmail.com>
	<e9601db2-ff7d-4490-abd5-8d3c5946e108@app.fastmail.com>
Date: Mon, 05 Jun 2023 16:06:13 +0300
In-Reply-To: <e9601db2-ff7d-4490-abd5-8d3c5946e108@app.fastmail.com> (Arnd
	Bergmann's message of "Sat, 03 Jun 2023 09:43:35 +0200")
Message-ID: <87zg5ehxdm.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

"Arnd Bergmann" <arnd@kernel.org> writes:

> On Mon, May 8, 2023, at 17:07, Arnd Bergmann wrote:
>
>> On Mon, May 8, 2023, at 16:57, Kalle Valo wrote:
>>> With older GCC versions from your page I don't have this problem. I'm
>>> using Debian 10 still so so is my libc too old?
>>
>> (dropping most Cc)
>>
>> Indeed, thanks for the report, I forgot about that issue. I used
>> to build the cross toolchains in an old Ubuntu 16.04 chroot to avoid
>> that issue, and I linked all other dependencies statically.
>>
>> The gcc-13.1.0 builds are the first ones I did on an arm64 machine,
>> so I had to create a new build environment and started out with
>> just my normal Debian testing rootfs, which caused me enough issues
>> to figure out first.
>>
>> I had previously experimented with linking statically against
>> musl to avoid all other dependencies, but that ended up with
>> slower binaries because the default memory allocator in musl
>> doesn't work that well for gcc, and I never quite figured out
>> how to pick a different memory allocator, or which one to use.
>>
>> I should probably just pick an older Debian release that is new
>> enough to contain cross compilers for arm64 and x86 and then
>> set up the same kind of chroot I had in before.
>
> It took me a while, but now I have a working build setup
> in a Debian Buster schroot with gcc-13 as the main compiler,
> and I updated the gcc-13.1 binaries with those, as well as
> uploading gcc-11.4 and gcc-12.3 build the same way.
>
> I have only tested the binaries on arm64 Debian testing,
> could you see if the new x86 builds work for you?

I tested GCC 12.3 and 13.1 on x86 Debian 10, they both worked perfectly.
Thank you!

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

