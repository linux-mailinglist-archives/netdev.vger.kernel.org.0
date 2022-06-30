Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1CD56249E
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 22:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235499AbiF3Uwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 16:52:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232936AbiF3Uwy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 16:52:54 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 211854477E;
        Thu, 30 Jun 2022 13:52:53 -0700 (PDT)
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1o719c-000GXE-SX; Thu, 30 Jun 2022 22:52:48 +0200
Received: from [85.1.206.226] (helo=linux-3.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1o719c-0000ps-Lc; Thu, 30 Jun 2022 22:52:48 +0200
Subject: Re: [PATCH bpf-next 4/4] selftests: xsk: destroy BPF resources only
 when ctx refcount drops to 0
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
References: <20220629143458.934337-1-maciej.fijalkowski@intel.com>
 <20220629143458.934337-5-maciej.fijalkowski@intel.com>
 <CAJ8uoz2Jc1=O4-BJ52QgijgD5fR3As+CXLRpeync=25hc-NDoA@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <1aa6952b-8ed5-f991-8c27-d7b7325f0929@iogearbox.net>
Date:   Thu, 30 Jun 2022 22:52:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAJ8uoz2Jc1=O4-BJ52QgijgD5fR3As+CXLRpeync=25hc-NDoA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26589/Thu Jun 30 10:08:14 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/30/22 11:58 AM, Magnus Karlsson wrote:
> On Wed, Jun 29, 2022 at 4:39 PM Maciej Fijalkowski
> <maciej.fijalkowski@intel.com> wrote:
>>
>> Currently, xsk_socket__delete frees BPF resources regardless of ctx
>> refcount. Xdpxceiver has a test to verify whether underlying BPF
>> resources would not be wiped out after closing XSK socket that was bound
>> to interface with other active sockets. From library's xsk part
>> perspective it also means that the internal xsk context is shared and
>> its refcount is bumped accordingly.
>>
>> After a switch to loading XDP prog based on previously opened XSK
>> socket, mentioned xdpxceiver test fails with:
>> not ok 16 [xdpxceiver.c:swap_xsk_resources:1334]: ERROR: 9/"Bad file descriptor
>>
>> which means that in swap_xsk_resources(), xsk_socket__delete() released
>> xskmap which in turn caused a failure of xsk_socket__update_xskmap().
>>
>> To fix this, when deleting socket, decrement ctx refcount before
>> releasing BPF resources and do so only when refcount dropped to 0 which
>> means there are no more active sockets for this ctx so BPF resources can
>> be freed safely.
> 
> Please fix this in libxdp too as the bug is present there also.
> 
> Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

[...]
>> @@ -1238,7 +1236,10 @@ void xsk_socket__delete(struct xsk_socket *xsk)
>>
>>          ctx = xsk->ctx;
>>          umem = ctx->umem;
>> -       if (ctx->prog_fd != -1) {
>> +
>> +       xsk_put_ctx(ctx, true);
>> +
>> +       if (!ctx->refcount) {
>>                  xsk_delete_bpf_maps(xsk);
>>                  close(ctx->prog_fd);
>>                  if (ctx->has_bpf_link)
>> @@ -1257,7 +1258,6 @@ void xsk_socket__delete(struct xsk_socket *xsk)
>>                  }
>>          }
>>
>> -       xsk_put_ctx(ctx, true);
>>
>>          umem->refcount--;

Applied & also fixed up the double newline. Thanks everyone!
