Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07FBF6AC937
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 18:06:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbjCFRGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 12:06:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbjCFRGR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 12:06:17 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 899946422A;
        Mon,  6 Mar 2023 09:05:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
        bh=f3FTquZp3c/eHfHktx78jQujAJkSeHVzjCriFAOCznM=; b=GSexObblB5eeLKEtNLhpcVgqRT
        RmRWZ77V90ip0+4Fy8ASa5nMHAEskZBM6cgwUhpIK7AoV3yIup2zjIv8gv7iqflSpyPS4vgAfDrqh
        NCkNJ0FEdBa/7hT8wrkK6hDy4t0Hc8Bkly/pGE+9Vu5aU2N43f7uVnpgtkXfKIlq7Q80z/Np8f7/R
        0RNpzXmabGAvM2gmvubgS6uWVW/qEf5gPJnX2lsiU1LrcZbAGBvPYAr/jouLQGCvWjiQYNtF4r+hT
        quoRpudD95+7RBj6OV1S+xVpR3V1IYkEd7OP9IcDVvxTYcFPoWS8h2OrhvPxepdsOjdsMzOrrgbhG
        U29Gdu2g==;
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1pZCsL-000MdA-PD; Mon, 06 Mar 2023 16:35:45 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1pZCsL-00061c-GR; Mon, 06 Mar 2023 16:35:45 +0100
Subject: Re: [PATCH bpf-next] selftests/bpf: use ifname instead of ifindex in
 XDP compliance test tool
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        lorenzo.bianconi@redhat.com
References: <5d11c9163490126fdc391dacb122480e4c059e62.1677863821.git.lorenzo@kernel.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <19947245-b305-f9c5-f79d-f79a152aaaaa@iogearbox.net>
Date:   Mon, 6 Mar 2023 16:35:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <5d11c9163490126fdc391dacb122480e4c059e62.1677863821.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.8/26833/Mon Mar  6 09:22:59 2023)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/3/23 6:21 PM, Lorenzo Bianconi wrote:
> Rely on interface name instead of interface index in error messages or logs
> from XDP compliance test tool.
> Improve XDP compliance test tool error messages.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>   tools/testing/selftests/bpf/xdp_features.c | 92 ++++++++++++++--------
>   1 file changed, 57 insertions(+), 35 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/xdp_features.c b/tools/testing/selftests/bpf/xdp_features.c
> index fce12165213b..7414801cd7ec 100644
> --- a/tools/testing/selftests/bpf/xdp_features.c
> +++ b/tools/testing/selftests/bpf/xdp_features.c
> @@ -25,6 +25,7 @@
>   
>   static struct env {
>   	bool verbosity;
> +	char ifname[IF_NAMESIZE];
>   	int ifindex;
>   	bool is_tester;
>   	struct {
> @@ -109,25 +110,25 @@ static int get_xdp_feature(const char *arg)
>   	return 0;
>   }
>   
> -static char *get_xdp_feature_str(void)
> +static char *get_xdp_feature_str(bool color)
>   {
>   	switch (env.feature.action) {
>   	case XDP_PASS:
> -		return YELLOW("XDP_PASS");
> +		return color ? YELLOW("XDP_PASS") : "XDP_PASS";
>   	case XDP_DROP:
> -		return YELLOW("XDP_DROP");
> +		return color ? YELLOW("XDP_DROP") : "XDP_DROP";
>   	case XDP_ABORTED:
> -		return YELLOW("XDP_ABORTED");
> +		return color ? YELLOW("XDP_ABORTED") : "XDP_ABORTED";
>   	case XDP_TX:
> -		return YELLOW("XDP_TX");
> +		return color ? YELLOW("XDP_TX") : "XDP_TX";
>   	case XDP_REDIRECT:
> -		return YELLOW("XDP_REDIRECT");
> +		return color ? YELLOW("XDP_REDIRECT") : "XDP_REDIRECT";
>   	default:
>   		break;
>   	}
>   
>   	if (env.feature.drv_feature == NETDEV_XDP_ACT_NDO_XMIT)
> -		return YELLOW("XDP_NDO_XMIT");
> +		return color ? YELLOW("XDP_NDO_XMIT") : "XDP_NDO_XMIT";
>   
>   	return "";
>   }

Please split this into multiple patches, logically separated. This one is changing
multiple things at once and above has not much relation to relying on interface names.

Thanks,
Daniel
