Return-Path: <netdev+bounces-9415-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 77A96728DB5
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 04:17:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 83C961C20E9D
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 02:17:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99F1B1113;
	Fri,  9 Jun 2023 02:17:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE26139A
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 02:17:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B09CC433EF;
	Fri,  9 Jun 2023 02:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686277033;
	bh=S6ApcEn9GU1V4Bvwrm/WCn0EJZfoTA9IJ2LkI8W+x+s=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ROelIoKFL2Cp4FfiyMijD6fyI8FQ+FthHHRJ6DxBbWS0r0PDkvjO+PJGEbpj8knCc
	 I6YlAvqxHWmFORuCgV8W5coUltR16QOXBHAJl6ZGmgETg2vh7+ZyhD80prWvO0QS3W
	 DA+T+wo2UjT7RpdlGVFnzJQYirf4ONJ1b8PRpy/YUWtetlRdKEkvIpsAt/Ydjte3rU
	 C/NCKyleh+u5vsPVvPC12gj4kAGl3icsyUk1IvQdcN6bruPikpu9fl2W3PU+XqA6sy
	 aHBOGsQbPM85VtD60jbJyFwiSeX7+5r9ch/UnxL00Yn2o/ox2snv70HW0rUYCSeAo7
	 yU2WSeLjCw7lw==
Date: Thu, 8 Jun 2023 19:17:12 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Magali Lemes <magali.lemes@canonical.com>
Cc: davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
 shuah@kernel.org, vfedorenko@novek.ru, tianjia.zhang@linux.alibaba.com,
 andrei.gherzan@canonical.com, netdev@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 1/3] selftests: net: tls: check if FIPS mode is
 enabled
Message-ID: <20230608191712.483dfe35@kernel.org>
In-Reply-To: <20230607174302.19542-2-magali.lemes@canonical.com>
References: <20230607174302.19542-1-magali.lemes@canonical.com>
	<20230607174302.19542-2-magali.lemes@canonical.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  7 Jun 2023 14:43:00 -0300 Magali Lemes wrote:
>  FIXTURE(tls)
>  {
> -	int fd, cfd;
> +	int fd, cfd, fips_enabled;

put bool fips_non_compliant into the variant, and mark down
the cases which need to be skipped. There is fewer variants
than tests

>  	bool notls;
>  };
>  
> @@ -309,7 +309,22 @@ FIXTURE_SETUP(tls)
>  {
>  	struct tls_crypto_info_keys tls12;
>  	int one = 1;
> -	int ret;
> +	int ret, res;
> +	FILE *f;
> +
> +	self->fips_enabled = 0;
> +	f = fopen("/proc/sys/crypto/fips_enabled", "r");
> +	if (f) {
> +		res = fscanf(f, "%d", &self->fips_enabled);
> +		if (res != 1)
> +			ksft_print_msg("ERROR: Couldn't read /proc/sys/crypto/fips_enabled\n");
> +		fclose(f);
> +	}

Cache the fips_enabled in a static global variable, no point reading 
it every time.
-- 
pw-bot: cr

