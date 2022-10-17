Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 073066015CA
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 19:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbiJQRyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 13:54:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbiJQRyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 13:54:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB2A51F601
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 10:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666029245;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vW045TRZg0HI3CVbl/qDr7ObashbGzCDeLwDHPt2cRk=;
        b=RDe+jnXrFO3GCZoRaXv8xa/p2egY//C9eGz895B5iFtgAwllsQYmU5nliRWWb0HZBSdzcX
        i0cT3ro818o+44hJrXLTieNg0sEC5nYVfC+V1v10v7tRBDqICYG6vcscZzi1XG57tNTwWH
        OIyBIOi1Tky/YHCqsb48dY7aWsY+VYg=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-605-bQD8r1VjOrGGOEbakH6FxA-1; Mon, 17 Oct 2022 13:54:04 -0400
X-MC-Unique: bQD8r1VjOrGGOEbakH6FxA-1
Received: by mail-qt1-f200.google.com with SMTP id e24-20020ac84918000000b0039878b3c676so8901669qtq.6
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 10:54:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vW045TRZg0HI3CVbl/qDr7ObashbGzCDeLwDHPt2cRk=;
        b=Qwb7Mox0RqsCh7HsN2LnLDsxxOEQ2HPhvYVKH/ezanxZSlNC2ILefhsuF/lsPlYrb/
         98hdOsei/bFmZ6Bk446Kmeg5PXJSXYKq6TqTIxuT0zNrhmGLFEC6tkwWNVefMNsaHa5o
         66UHRJkLbyqti2iPj59SJqjxtQkfgHQiOb/qqkOvr7Xr1mmpuD1KbatZPnsrdvysOjS7
         WAyQefpHFZegcvQCnZ3lG/AuqzSavbfqQAqozqDZKFVpKu5tJaQzddZ8W1i18SuIDClR
         eLAc/WHiHbSXkMW2VAUwkTy1bRhiSt8184euySJfQogapDW+pniSPxUJPQXBDydveiF0
         tCyw==
X-Gm-Message-State: ACrzQf2dwoer0YWK9PuQnkuoBg+KVHrAWjWwyMUqflQAXGRK9G8tHzEe
        jmLMkGZxATpQvHYJAqDlp9nvskudoLNXPxwlfC7Ll4fr7YskKKzR3gkMbzZiYe9d2TIkP2zcmVa
        j8C9BBdWIdNhUShYo
X-Received: by 2002:a05:620a:2618:b0:6ea:908:120e with SMTP id z24-20020a05620a261800b006ea0908120emr8354728qko.645.1666029243934;
        Mon, 17 Oct 2022 10:54:03 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5MnZRI/+y7OnMntAppb+WoMmHAqSPseNR2wkk3kcHFTfjDcUN7CIaRXFJasqXSEgtakgiexA==
X-Received: by 2002:a05:620a:2618:b0:6ea:908:120e with SMTP id z24-20020a05620a261800b006ea0908120emr8354717qko.645.1666029243706;
        Mon, 17 Oct 2022 10:54:03 -0700 (PDT)
Received: from [192.168.98.18] ([107.12.98.143])
        by smtp.gmail.com with ESMTPSA id x7-20020ac87ec7000000b0038d9555b580sm276689qtj.44.2022.10.17.10.54.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Oct 2022 10:54:01 -0700 (PDT)
Message-ID: <ad1c232c-e209-162d-1fa6-65702b5af121@redhat.com>
Date:   Mon, 17 Oct 2022 13:53:55 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: kselftest: bonding: dev_addr_lists.sh doesn't run due to lack of
 dependencies
Content-Language: en-US
To:     Benjamin Poirier <bpoirier@nvidia.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org
References: <40f04ded-0c86-8669-24b1-9a313ca21076@redhat.com>
 <Y0dejgSk60iZaJ/4@d3>
From:   Jonathan Toppins <jtoppins@redhat.com>
In-Reply-To: <Y0dejgSk60iZaJ/4@d3>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/12/22 20:40, Benjamin Poirier wrote:
> On 2022-10-12 10:17 -0400, Jonathan Toppins wrote:
>> When kselftest for bonding is built like:
>> $ make TARGETS="drivers/net/bonding" -j8 -C tools/testing/selftests gen_tar
>>
>> and then run on the target:
>> $ ./run_kselftest.sh
>> [...]
>> # selftests: drivers/net/bonding: dev_addr_lists.sh
>> # ./dev_addr_lists.sh: line 17: ./../../../net/forwarding/lib.sh: No such
>> file or directory
>> # ./dev_addr_lists.sh: line 107: tests_run: command not found
>> # ./dev_addr_lists.sh: line 109: exit: : numeric argument required
>> # ./dev_addr_lists.sh: line 34: pre_cleanup: command not found
>> not ok 4 selftests: drivers/net/bonding: dev_addr_lists.sh # exit=2
>> [...]
>>
>> I am still new to kselftests is this expected or is there some way in the
>> make machinery to force packaging of net as well?
>>
> 
> Arg, I didn't know that you could export just a part of the selftest
> tree. Thanks for the report.
> 
> I'm traveling for a few days. I'll look into how to fix the inclusion
> problem when I get back on October 19th.
> 
> In the meantime, if you just want to run the bonding tests you can do:
> 
> (in tree)
> make -C tools/testing/selftests run_tests TARGETS="drivers/net/bonding"
> 
> or
> 
> (exported)
> make -C tools/testing/selftests gen_tar
> [... extract archive ...]
> ./run_kselftest.sh -c drivers/net/bonding
> 
> 
> It seems like a plausible fix might be to use symlinks, what do you
> think?

This looks good to me. I might rename `lib.sh` to `net_lib.sh` but that 
is just a nit.

-Jon

> 
> diff --git a/tools/testing/selftests/drivers/net/bonding/Makefile b/tools/testing/selftests/drivers/net/bonding/Makefile
> index e9dab5f9d773..7c50bfc24d32 100644
> --- a/tools/testing/selftests/drivers/net/bonding/Makefile
> +++ b/tools/testing/selftests/drivers/net/bonding/Makefile
> @@ -7,6 +7,8 @@ TEST_PROGS := \
>   	bond-lladdr-target.sh \
>   	dev_addr_lists.sh
>   
> -TEST_FILES := lag_lib.sh
> +TEST_FILES := \
> +	lag_lib.sh \
> +	lib.sh
>   
>   include ../../../lib.mk
> diff --git a/tools/testing/selftests/drivers/net/bonding/dev_addr_lists.sh b/tools/testing/selftests/drivers/net/bonding/dev_addr_lists.sh
> index e6fa24eded5b..7b79f090ddaa 100755
> --- a/tools/testing/selftests/drivers/net/bonding/dev_addr_lists.sh
> +++ b/tools/testing/selftests/drivers/net/bonding/dev_addr_lists.sh
> @@ -14,7 +14,7 @@ ALL_TESTS="
>   REQUIRE_MZ=no
>   NUM_NETIFS=0
>   lib_dir=$(dirname "$0")
> -source "$lib_dir"/../../../net/forwarding/lib.sh
> +source "$lib_dir"/lib.sh
>   
>   source "$lib_dir"/lag_lib.sh
>   
> diff --git a/tools/testing/selftests/drivers/net/bonding/lib.sh b/tools/testing/selftests/drivers/net/bonding/lib.sh
> new file mode 120000
> index 000000000000..39c96828c5ef
> --- /dev/null
> +++ b/tools/testing/selftests/drivers/net/bonding/lib.sh
> @@ -0,0 +1 @@
> +../../../net/forwarding/lib.sh
> \ No newline at end of file
> diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
> index 9d4cb94cf437..6203d3993554 100644
> --- a/tools/testing/selftests/lib.mk
> +++ b/tools/testing/selftests/lib.mk
> @@ -84,7 +84,7 @@ endif
>   
>   define INSTALL_SINGLE_RULE
>   	$(if $(INSTALL_LIST),@mkdir -p $(INSTALL_PATH))
> -	$(if $(INSTALL_LIST),rsync -a $(INSTALL_LIST) $(INSTALL_PATH)/)
> +	$(if $(INSTALL_LIST),rsync -aL $(INSTALL_LIST) $(INSTALL_PATH)/)
>   endef
>   
>   define INSTALL_RULE
> 

