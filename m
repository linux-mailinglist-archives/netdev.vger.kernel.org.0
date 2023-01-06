Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE05D66070F
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 20:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234814AbjAFTWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 14:22:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235789AbjAFTWm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 14:22:42 -0500
Received: from smtp-bc0d.mail.infomaniak.ch (smtp-bc0d.mail.infomaniak.ch [IPv6:2001:1600:3:17::bc0d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51D3E43E57
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 11:22:41 -0800 (PST)
Received: from smtp-2-0001.mail.infomaniak.ch (unknown [10.5.36.108])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4NpYBh6TpjzMr6M3;
        Fri,  6 Jan 2023 20:22:36 +0100 (CET)
Received: from unknown by smtp-2-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4NpYBg6kwJzMppKr;
        Fri,  6 Jan 2023 20:22:35 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1673032956;
        bh=6OCpciQuYs/fuH7eKfax3wZFytmN21aeZpdhduiqY0c=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=XH9Zr+q6eH9CLaHWF81v8o5NvIjUwf3EZMSx1Lz71eC/zHSarCFa5KGEzipW9jN0u
         hiynpCclKr/dxtVtdfy8mWXAPMGv5S9jPIpXNpBRFaiiA9AWfxSRUcIxDoZfunfSVy
         0G3Yic5RoCwPuys8FoslWtvdD+C6zE0bdR7vJzmE=
Message-ID: <47fedda8-a13c-b62f-251f-b62508964bb0@digikod.net>
Date:   Fri, 6 Jan 2023 20:22:35 +0100
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v8 07/12] landlock: Add network rules support
Content-Language: en-US
To:     "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>,
        linux-sparse@vger.kernel.org
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, artem.kuzin@huawei.com,
        Linux API <linux-api@vger.kernel.org>,
        "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
References: <20221021152644.155136-1-konstantin.meskhidze@huawei.com>
 <20221021152644.155136-8-konstantin.meskhidze@huawei.com>
 <49391484-7401-e7c7-d909-3bd6bd024731@digikod.net>
 <9a6ea6ac-525d-e058-5867-0794a99b19a3@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <9a6ea6ac-525d-e058-5867-0794a99b19a3@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 04/01/2023 12:41, Konstantin Meskhidze (A) wrote:
> 
> 
> 11/17/2022 9:43 PM, Mickaël Salaün пишет:

[...]

>>>    /**
>>> @@ -79,6 +91,24 @@ struct landlock_path_beneath_attr {
>>>    	 */
>>>    } __attribute__((packed));
>>>
>>> +/**
>>> + * struct landlock_net_service_attr - TCP subnet definition
>>> + *
>>> + * Argument of sys_landlock_add_rule().
>>> + */
>>> +struct landlock_net_service_attr {
>>> +	/**
>>> +	 * @allowed_access: Bitmask of allowed access network for services
>>> +	 * (cf. `Network flags`_).
>>> +	 */
>>> +	__u64 allowed_access;
>>> +	/**
>>> +	 * @port: Network port.
>>> +	 */
>>> +	__u16 port;
>>
>>    From an UAPI point of view, I think the port field should be __be16, as
>> for sockaddr_in->port and other network-related APIs. This will require
>> some kernel changes to please sparse: make C=2 security/landlock/ must
>> not print any warning.
> 
>     I have this errors trying to launch sparse checking:
> 
>     DESCEND objtool
>     DESCEND bpf/resolve_btfids
>     CALL    scripts/checksyscalls.sh
>     CHK     kernel/kheaders_data.tar.xz
>     CC      security/landlock/setup.o
>     CHECK   security/landlock/setup.c
> ./include/asm-generic/rwonce.h:67:16: error: typename in expression
> ./include/asm-generic/rwonce.h:67:16: error: Expected ) in function call
> ./include/asm-generic/rwonce.h:67:16: error: got :
> ./include/linux/list.h:292:16: error: typename in expression
> ./include/linux/list.h:292:16: error: Expected ) in function call
> ./include/linux/list.h:292:16: error: got :
> 
> ....
> 
> ./include/linux/seqlock.h:682:16: error: Expected ) in function call
> ./include/linux/seqlock.h:682:16: error: got :
> ./include/linux/seqlock.h:695:16: error: typename in expression
> ./include/linux/seqlock.h:695:16: error: Expected ) in function call
> ./include/linux/seqlock.h:695:16: error: too many errors
> Segmentation fault (core dumped)
> make[3]: *** [scripts/Makefile.build:250: security/landlock/setup.o]
> Error 139
> make[3]: *** Deleting file 'security/landlock/setup.o'
> make[3]: *** Waiting for unfinished jobs....
> Segmentation fault (core dumped)
> make[3]: *** [scripts/Makefile.build:250: security/landlock/syscalls.o]
> Error 139
> make[3]: *** Deleting file 'security/landlock/syscalls.o'
> make[2]: *** [scripts/Makefile.build:502: security/landlock] Error 2
> make[1]: *** [scripts/Makefile.build:502: security] Error 2
> make[1]: *** Waiting for unfinished jobs....
> make: *** [Makefile:1994: .] Error 2

I don't know about this error. Did you follow the documentation?
https://docs.kernel.org/dev-tools/sparse.html#getting-sparse



>>
>> Using big-endian values as keys (casted to uintptr_t, not strictly
>> __be16) in the rb-tree should not be an issue because there is no port
>> range ordering (for now).
>>
>> A dedicated test should check that endianness is correct, e.g. by using
>> different port encoding. This should include passing and failing tests,
>> but they should work on all architectures (i.e. big or little endian).
