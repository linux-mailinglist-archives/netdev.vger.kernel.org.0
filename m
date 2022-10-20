Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 439516060EA
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 15:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbiJTNF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 09:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiJTNFZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 09:05:25 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 543E87B59E;
        Thu, 20 Oct 2022 06:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=NWlc310zC7A6PzgS1tsh9XKSC/ZSkVdRECs80RWWAgI=; b=PP9BgVwp0DfW+DgcGcsf95PAz2
        iaYQJAhGiuoUdYD8Dqhh2p7gIqnG21+KecaMZyLX8nYC9D/5HkLLfnX3oNXuRyxmZCIsncRiCYbKZ
        wbAJS+20Y83VywHJJeJ190GRNGWeaKx8J5X5DUP4wPHLYLe6F2jv1dyVmwi5rVNfJGqZKtTB22ODO
        FdahqeBj1QOdSoJAwPZGPSACyPEXqq89XLFKwhhCAzHp6JeFEKSMjjjfd8ZoeUajXI0tTe9Obdtgg
        Kzc3VifCc9/Uj1nA2ZWy5FXcwmg1KhMTulL4EDVeXI4ER4TcL/Ba0FBcIz43mNP7Szv1jFIX/rj6/
        AHeyjDYKeWRPhBDv+Onh7OGgO5dnGvWx5oyot1ypUsY1AXSYh716wEW+6XHfQyCutehPnwOPQLmD/
        RWlhGuG/HpbXY/hp2rBxM9xswjgpfLFm+lz0ItRvwOih0aoafVvW0zzAz9LUAS5sk8qRN/TxqHusK
        O+IEeBVO946dOrHTd/wA11/e;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1olVEd-0050vJ-F4; Thu, 20 Oct 2022 13:05:19 +0000
Message-ID: <83044495-2ac1-859f-42b2-4be358541fe2@samba.org>
Date:   Thu, 20 Oct 2022 15:05:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, netdev@vger.kernel.org
References: <cover.1666229889.git.asml.silence@gmail.com>
 <ee7c163db8cea65b208d327610a6a96f936c1c6f.1666229889.git.asml.silence@gmail.com>
 <f60d98e7-c798-b4a9-f305-4adc16341eca@samba.org>
 <d2eb10cb-3cce-429c-7a72-7153b5442377@gmail.com>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH for-6.1 1/2] io_uring/net: fail zc send for unsupported
 protocols
In-Reply-To: <d2eb10cb-3cce-429c-7a72-7153b5442377@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pavel,

>> Maybe the socket creation code could set
>> unsigned char skc_so_zerocopy_supported:1;
>> and/or
>> unsigned char skc_zerocopy_msg_ubuf_supported:1;
>>
>> In order to avoid the manual complex tests.
>>
>> What do you think?
> 
> Ok, wanted to do it rather later but let me to try fiddle with it.

Thanks!

> btw, what's happening with smbdirect? Do you plan upstream it one day
> and it's just maturing out of tree?

Yes, once its stable and useful. My current plan (as time permits) is
this:

1. get the samba_io_uring_ev tevent backend working (with current kernels),
    see my other recent mail on that.
2. add OP_SENDMSG[_ZC]/OP_RECVMSG and OP_SPLICE support for the file server
    part of Samba ready (based on 1.)
3. try to get a stripped down version of the smbdirect module ready to be used
    in cifs.ko (without exporting smbdirect sockets to userspace) upstream
4. extend the smbdirect module to be able to be used by ksmbd upstreamed
5. get the uapi for MSG_OOB and msg_control stable for samba's client and server
    into a useful state and then export AF_SMBDIRECT exported to userspace

I hope to get 1 and 2 ready in the next weeks...

metze
