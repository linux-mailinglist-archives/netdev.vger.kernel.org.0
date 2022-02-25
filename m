Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDEE94C4BF4
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 18:22:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243613AbiBYRXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 12:23:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243616AbiBYRWt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 12:22:49 -0500
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B9A9223204;
        Fri, 25 Feb 2022 09:22:17 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: usama.anjum)
        with ESMTPSA id AF3891F464FE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1645809736;
        bh=vRZrrE/MYE3yCl0TC9kgOrEfpCGgFVkg67K4UVbuhLM=;
        h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
        b=Qx+Hc3b6kRJW0YO/JRuwx//SvYjkK8g9zQoi0prEf8lHFZasKm648AGmT72uT65ea
         R+6o7+DsrtqWQdQyb31s4NDbKXh53Di8Rp9HDd0aTHoiq1RaLtCa7s9htuE1oH9gql
         zvLLQe0lNqZCTAJTwlVe75GOrWCByCY7/2lnrR+VqTDIIesnDuDisg/CToVsZATPnc
         QXhRoP7TN7AmYqyvgbC7I7HWKbXSEwvpcsEHcPCGJbqwiMJvC8zf30FVUkTltqRoT4
         AgjhaE+ww/OuCm2Kn4JnlzB4hqXGwLbuY7D2oqM+Z8+GbXr+wyd54dwDDEPMuQDdmg
         mun5B1+/yeulg==
Message-ID: <46489cd9-fb7a-5a4b-7f36-1c9f6566bd93@collabora.com>
Date:   Fri, 25 Feb 2022 22:22:08 +0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Cc:     usama.anjum@collabora.com, kernel@collabora.com,
        kernelci@groups.io, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH V2] selftests: Fix build when $(O) points to a relative
 path
Content-Language: en-US
To:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
References: <20220216223817.1386745-1-usama.anjum@collabora.com>
From:   Muhammad Usama Anjum <usama.anjum@collabora.com>
In-Reply-To: <20220216223817.1386745-1-usama.anjum@collabora.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Any thoughts about it?

On 2/17/22 3:38 AM, Muhammad Usama Anjum wrote:
> Build of bpf and tc-testing selftests fails when the relative path of
> the build directory is specified.
> 
> make -C tools/testing/selftests O=build0
> make[1]: Entering directory '/linux_mainline/tools/testing/selftests/bpf'
> ../../../scripts/Makefile.include:4: *** O=build0 does not exist.  Stop.
> make[1]: Entering directory '/linux_mainline/tools/testing/selftests/tc-testing'
> ../../../scripts/Makefile.include:4: *** O=build0 does not exist.  Stop.
> 
> Makefiles of bpf and tc-testing include scripts/Makefile.include file.
> This file has sanity checking inside it which checks the output path.
> The output path is not relative to the bpf or tc-testing. The sanity
> check fails. Expand the output path to get rid of this error. The fix is
> the same as mentioned in commit 150a27328b68 ("bpf, preload: Fix build
> when $(O) points to a relative path").
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
> ---
> Changes in V2:
> Add more explaination to the commit message.
> Support make install as well.
> ---
>  tools/testing/selftests/Makefile | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
> index 4eda7c7c15694..6a5c25fcc9cfc 100644
> --- a/tools/testing/selftests/Makefile
> +++ b/tools/testing/selftests/Makefile
> @@ -178,6 +178,7 @@ all: khdr
>  		BUILD_TARGET=$$BUILD/$$TARGET;			\
>  		mkdir $$BUILD_TARGET  -p;			\
>  		$(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET	\
> +				O=$(abs_objtree)		\
>  				$(if $(FORCE_TARGETS),|| exit);	\
>  		ret=$$((ret * $$?));				\
>  	done; exit $$ret;
> @@ -185,7 +186,8 @@ all: khdr
>  run_tests: all
>  	@for TARGET in $(TARGETS); do \
>  		BUILD_TARGET=$$BUILD/$$TARGET;	\
> -		$(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET run_tests;\
> +		$(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET run_tests \
> +				O=$(abs_objtree);		    \
>  	done;
>  
>  hotplug:
> @@ -236,6 +238,7 @@ ifdef INSTALL_PATH
>  	for TARGET in $(TARGETS); do \
>  		BUILD_TARGET=$$BUILD/$$TARGET;	\
>  		$(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET INSTALL_PATH=$(INSTALL_PATH)/$$TARGET install \
> +				O=$(abs_objtree)		\
>  				$(if $(FORCE_TARGETS),|| exit);	\
>  		ret=$$((ret * $$?));		\
>  	done; exit $$ret;
