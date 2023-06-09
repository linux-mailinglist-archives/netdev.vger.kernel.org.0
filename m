Return-Path: <netdev+bounces-9687-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 168CC72A2FF
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 21:21:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 65B1B1C20E52
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 19:21:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0A2E1B8E2;
	Fri,  9 Jun 2023 19:21:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6191408E7
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 19:21:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D04D8C4339E;
	Fri,  9 Jun 2023 19:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686338477;
	bh=sSEGVfG+v8CWDd65ui9wgJPVlohhSQJriUCAmoaXyxU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=r/wnpri8KtZ+LjIg0X2XNzH+aIMb5TVqVm21DZtm0t/rvW7mL/KquY31CXoNOSL13
	 qnFcqqJZyU38ZZYbLu+zNA18wsd4YqynOljJkMcv1nNgdqNWvRKrbZr8gD/GOxLeuI
	 F++t0Mipdxq5Y4GcPgofGztW0v1Rg8FBT+zcN6qnLyjTeFpdl1/1p+zexJ6nL5XDpr
	 hJrbC+lmbnI59L3YfsxaNS1O0WGu4aREUcOhHODsu2uXBp+aKZA1O03wyhDB30BTa3
	 XIN9WEahpdTjMkoEGIuOhWt4kMTsllLoxZh1BFG6Y63KqmHEqNQcKWVctvwvnsBTXc
	 BqnmysOSM8QsQ==
Date: Fri, 9 Jun 2023 12:21:15 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Magali Lemes do Sacramento <magali.lemes@canonical.com>
Cc: davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
 shuah@kernel.org, vfedorenko@novek.ru, tianjia.zhang@linux.alibaba.com,
 andrei.gherzan@canonical.com, netdev@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2 1/3] selftests: net: tls: check if FIPS mode is
 enabled
Message-ID: <20230609122115.25dca627@kernel.org>
In-Reply-To: <CAO9q4O0KpMxukPLxvhyNj692vBSUzygdLQi3Ek1QUJbeYJhyag@mail.gmail.com>
References: <20230609164324.497813-1-magali.lemes@canonical.com>
	<20230609164324.497813-2-magali.lemes@canonical.com>
	<20230609105307.492cd1f2@kernel.org>
	<CAO9q4O0KpMxukPLxvhyNj692vBSUzygdLQi3Ek1QUJbeYJhyag@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 9 Jun 2023 15:52:10 -0300 Magali Lemes do Sacramento wrote:
> > No need to zero init static variables, but really instead of doing
> > the main() hack you should init this to a return value of a function.
> > And have that function read the value.
> 
> I'm not sure I understand what you mean here. I agree we want to avoid
> reading the /proc/sys/crypto/fips_enabled file for every test.
> However, correct me where I'm wrong, if we want to have fips_enabled
> as a static global variable I don't think we can directly initialize
> it from the return value of a function.
> Could you clarify that, please?

Hm, I thought that worked, I must be misremembering.
If it doesn't - let's steal the trick that the harness itself uses and
put the init in a function decorated with __attribute__((constructor)).

