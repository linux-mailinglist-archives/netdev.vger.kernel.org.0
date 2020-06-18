Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40E7F1FF838
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 17:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729227AbgFRPyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 11:54:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:57130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728090AbgFRPyT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 11:54:19 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B76BF2070A;
        Thu, 18 Jun 2020 15:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592495658;
        bh=jKjzWSYaAIzGjmzUCmr0zTy77wE+77rvCq+YS0N2G3I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Cw5K3soIhpwJM4Y1ekQp9nAcJhMki7OpuMX8PAealyUkLJm2ZCeAijDt+iCBomOLj
         f6yIChv22Yl7EY65kFTJlV1b93hr5SdatrIAoiS84R2hvJG7JBAxbT7Ba0Wp424FVc
         2Ki0qQA7pHdmYYS0g5MNlR31g1MocvHMKZ7qt9mY=
Date:   Thu, 18 Jun 2020 08:54:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH net] selftests/net: report etf errors correctly
Message-ID: <20200618085416.48b44e51@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200618145549.37937-1-willemdebruijn.kernel@gmail.com>
References: <20200618145549.37937-1-willemdebruijn.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Jun 2020 10:55:49 -0400 Willem de Bruijn wrote:
> +		switch (err->ee_errno) {
> +		case ECANCELED:
> +			if (err->ee_code != SO_EE_CODE_TXTIME_MISSED)
> +				error(1, 0, "errqueue: unknown ECANCELED %u\n",
> +					    err->ee_code);
> +			reason = "missed txtime";
> +		break;
> +		case EINVAL:
> +			if (err->ee_code != SO_EE_CODE_TXTIME_INVALID_PARAM)
> +				error(1, 0, "errqueue: unknown EINVAL %u\n",
> +					    err->ee_code);
> +			reason = "invalid txtime";
> +		break;
> +		default:
> +			error(1, 0, "errqueue: errno %u code %u\n",
> +			      err->ee_errno, err->ee_code);
> +		};
>  
>  		tstamp = ((int64_t) err->ee_data) << 32 | err->ee_info;
>  		tstamp -= (int64_t) glob_tstart;
>  		tstamp /= 1000 * 1000;
> -		fprintf(stderr, "send: pkt %c at %" PRId64 "ms dropped\n",
> -				data[ret - 1], tstamp);
> +		fprintf(stderr, "send: pkt %c at %" PRId64 "ms dropped: %s\n",
> +				data[ret - 1], tstamp, reason);

Hi Willem! Checkpatch is grumpy about some misalignment here:

CHECK: Alignment should match open parenthesis
#67: FILE: tools/testing/selftests/net/so_txtime.c:187:
+				error(1, 0, "errqueue: unknown ECANCELED %u\n",
+					    err->ee_code);

CHECK: Alignment should match open parenthesis
#73: FILE: tools/testing/selftests/net/so_txtime.c:193:
+				error(1, 0, "errqueue: unknown EINVAL %u\n",
+					    err->ee_code);

CHECK: Alignment should match open parenthesis
#87: FILE: tools/testing/selftests/net/so_txtime.c:205:
+		fprintf(stderr, "send: pkt %c at %" PRId64 "ms dropped: %s\n",
+				data[ret - 1], tstamp, reason);
