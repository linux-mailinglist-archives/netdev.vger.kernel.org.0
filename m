Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45C0D55F969
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 09:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232381AbiF2Hmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 03:42:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbiF2Hmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 03:42:36 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE09B36B77;
        Wed, 29 Jun 2022 00:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=GmpOlUfnxy0DLrQYEO1ULGDxnDIGv7boJt2o11jQeVA=; b=DVtuL5tifKTVNFaYPWCbVKMYhQ
        Zb1GXMENp8LkuEJPqsyU97T/4UGeg7scCvLUyEknOeUemr3brM03hAviRCQ8BBwvGrlJ3GhkqCLzY
        poDJyc6lQuQpoXVmycSb2DJR5UmX6qvpM79geWSZwzehEdRMruMS0vWAK3UX5NjlXIzkAl2otTHbZ
        CejBODyM1MMT3gyGgMw8vKoi0joTo7sD/Yn3bgUqa7ZXImpNQ3cZlU+m90bzvhkRvdq2BQRGk5734
        ABaKBnHfzpgEQ7WZ04nywtq7Pamli1UWZmLeY9V/GtDG1CLRhuQqM0pt2mQmWtiTPTimW1MP5nNqk
        vg0+YYGfuYkh6dse+HK1RBTZ/UeTplQUtUKtAp3SEojxvE4qpZkPzwZ5682OPGFrsaJ+3YpgwQcBJ
        D71yyKwepye126Cfijj9JzkoGEqTrRXHgSEnMS4amk5ZbKZxt7YU/b33ZYO+C8E1G4JSB/+xkV7xK
        m5FSWyXoLiqMT7m0mNoAtH/v;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1o6SL5-002FBl-Vi; Wed, 29 Jun 2022 07:42:20 +0000
Message-ID: <cccec667-d762-9bfd-f5a5-1c9fb46df5af@samba.org>
Date:   Wed, 29 Jun 2022 09:42:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, kernel-team@fb.com
References: <cover.1653992701.git.asml.silence@gmail.com>
 <228d4841af5eeb9a4b73955136559f18cb7e43a0.1653992701.git.asml.silence@gmail.com>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [RFC net-next v3 23/29] io_uring: allow to pass addr into sendzc
In-Reply-To: <228d4841af5eeb9a4b73955136559f18cb7e43a0.1653992701.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Pavel,

>   
> +	if (zc->addr) {
> +		ret = move_addr_to_kernel(zc->addr, zc->addr_len, &address);
> +		if (unlikely(ret < 0))
> +			return ret;
> +		msg.msg_name = (struct sockaddr *)&address;
> +		msg.msg_namelen = zc->addr_len;
> +	}
> +

Given that this fills in msg almost completely can we also have
a version of SENDMSGZC, it would be very useful to also allow
msg_control to be passed and as well as an iovec.

Would that be possible?

Do I understand it correctly, that the reason for the new opcode is,
that IO_OP_SEND would already work with existing MSG_ZEROCOPY behavior, together
with the recvmsg based completion?

In addition I wondering if a completion based on msg_iocb->ki_complete() (indicated by EIOCBQUEUED)
what have also worked, just deferring the whole sendmsg operation until all buffers are no longer used.
That way it would be possible to buffers are acked by the remote end when it comes back to the application
layer.

I'm also wondering if the ki_complete() based approach should always be provided to sock_sendmsg()
triggered by io_uring (independend of the new zerocopy stuff), it would basically work very simular to
the uring_cmd() completions, which are able to handle both true async operation indicated by EIOCBQUEUED
as well as EAGAIN triggered path via io-wq.

metze
