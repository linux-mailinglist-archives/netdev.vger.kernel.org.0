Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE735B19AF
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 12:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbiIHKKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 06:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbiIHKKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 06:10:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90A9C786CA
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 03:10:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662631835;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J5bbihJxibbZG98nvmOoRyWPRDe2h39ZD/bGM+Jcg48=;
        b=M6wbdEalLKUC9hmr5+8v8FfCVCF5egSKv9tM96Tb9NKVfpOgpAgBnhqHGO1Q9HVidW/1ew
        3cN5XUrp12P/bYOukSwuQgNrH558RfzXNGra6klxh1E+/25eL9ZONJ7en1O+N66045/phH
        aneXW3jKRvFJx4KlnK2fnzm4uMRXMk0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-397-t9C_UnEvOd29dkvzPs21Nw-1; Thu, 08 Sep 2022 06:10:34 -0400
X-MC-Unique: t9C_UnEvOd29dkvzPs21Nw-1
Received: by mail-wm1-f69.google.com with SMTP id c128-20020a1c3586000000b003b324bb08c5so665340wma.9
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 03:10:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=J5bbihJxibbZG98nvmOoRyWPRDe2h39ZD/bGM+Jcg48=;
        b=Z1xFdMgGLyBcns5dVu0VE2eVxk2IaSX5fsMFSIxj4fqjQcedf9Zkky/sTrr2UwZjGM
         WsiPp64/1wElNPHHYESJWns/xgdduGjknc97zzr8Q3RVgmH1MAF/YhKSR+pO8KmWWd3M
         DHbJSS6JMrEotGI4ygqkCYx0GxBgwwwn0zsYeyNbLMX6vZQ4yXNu+VPajQMLlIUgrqL2
         qSXYYiLqqvV2qNwfF22HJYCxNhOb9IZwcleCkOlG/rMkAX6VfOuouw6jIBMJwKi3O9jy
         CdOgUsRnDYfmJaZ9qg4qeUOVSrp5NtQifuquDulWeH/LLKzxGnn6G9xPulyD0DyEB9AQ
         ifBA==
X-Gm-Message-State: ACgBeo2d11Dp9p7WP9QPbLr7wrl8XoOOD3tzva7rBHRoNhvBylj1r0iO
        SjeDsVhgBQXbT7IbMsqrLF5QMWXrTgHT/T3xLbto48cbn1Xk3EptB9cyiIpvxTuSuvQ/sx2zhdM
        SBngcxOGMAiiJvj7N
X-Received: by 2002:a05:6000:1d93:b0:22a:3318:860d with SMTP id bk19-20020a0560001d9300b0022a3318860dmr887177wrb.352.1662631833679;
        Thu, 08 Sep 2022 03:10:33 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5j89wi/Zu5U7jnKd0D8sJ2jzDuep/sdQH8t6zKveJvmPbUuarPvV4XeisBWFaemKR+F4jq/g==
X-Received: by 2002:a05:6000:1d93:b0:22a:3318:860d with SMTP id bk19-20020a0560001d9300b0022a3318860dmr887152wrb.352.1662631833406;
        Thu, 08 Sep 2022 03:10:33 -0700 (PDT)
Received: from [192.168.0.4] ([78.17.187.218])
        by smtp.gmail.com with ESMTPSA id c7-20020adfe747000000b00226dfac0149sm15392967wrn.114.2022.09.08.03.10.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Sep 2022 03:10:33 -0700 (PDT)
Message-ID: <b5f0d10d-2d4e-34d6-1e45-c206cb6f5d26@redhat.com>
Date:   Thu, 8 Sep 2022 11:10:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.2.1
Subject: Re: [PATCH RFCv2 bpf-next 17/18] xsk: AF_XDP xdp-hints support in
 desc options
Content-Language: en-US
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        xdp-hints@xdp-project.net, larysa.zaremba@intel.com,
        memxor@gmail.com, Lorenzo Bianconi <lorenzo@kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        dave@dtucker.co.uk, Magnus Karlsson <magnus.karlsson@intel.com>,
        bjorn@kernel.org
References: <166256538687.1434226.15760041133601409770.stgit@firesoul>
 <166256558657.1434226.7390735974413846384.stgit@firesoul>
 <CAJ8uoz3UcC2tnMtG8W6a3HpCKgaYSzSCqowLFQVwCcsr+NKBOQ@mail.gmail.com>
From:   Maryam Tahhan <mtahhan@redhat.com>
In-Reply-To: <CAJ8uoz3UcC2tnMtG8W6a3HpCKgaYSzSCqowLFQVwCcsr+NKBOQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/09/2022 09:06, Magnus Karlsson wrote:
> On Wed, Sep 7, 2022 at 5:48 PM Jesper Dangaard Brouer <brouer@redhat.com> wrote:
>>
>> From: Maryam Tahhan <mtahhan@redhat.com>
>>
>> Simply set AF_XDP descriptor options to XDP flags.
>>
>> Jesper: Will this really be acceptable by AF_XDP maintainers?
> 
> Maryam, you guessed correctly that dedicating all these options bits
> for a single feature will not be ok :-). E.g., I want one bit for the
> AF_XDP multi-buffer support and who knows what other uses there might
> be for this options field in the future. Let us try to solve this in
> some other way. Here are some suggestions, all with their pros and
> cons.
> 

TBH it was Jespers question :)

> * Put this feature flag at a known place in the metadata area, for
> example just before the BTF ID. No need to fill this in if you are not
> redirecting to AF_XDP, but at a redirect to AF_XDP, the XDP flags are
> copied into this u32 in the metadata area so that user-space can
> consume it. Will cost 4 bytes of the metadata area though.

If Jesper agrees I think this approach would make sense. Trying to
translate encodings into some other flags for AF_XDP I think will lead
to a growing set of translations as more options come along.
The other thing to be aware of is just making sure to clear/zero the 
metadata space in the buffers at some point (ideally when the descriptor 
is returned from the application) so when the buffers are used again
they are already in a "reset" state.

> 
> * Instead encode this information into each metadata entry in the
> metadata area, in some way so that a flags field is not needed (-1
> signifies not valid, or whatever happens to make sense). This has the
> drawback that the user might have to look at a large number of entries
> just to find out there is nothing valid to read. To alleviate this, it
> could be combined with the next suggestion.
> 
> * Dedicate one bit in the options field to indicate that there is at
> least one valid metadata entry in the metadata area. This could be
> combined with the two approaches above. However, depending on what
> metadata you have enabled, this bit might be pointless. If some
> metadata is always valid, then it serves no purpose. But it might if
> all enabled metadata is rarely valid, e.g., if you get an Rx timestamp
> on one packet out of one thousand.
> 
>> Signed-off-by: Maryam Tahhan <mtahhan@redhat.com>
>> ---
>>   include/uapi/linux/if_xdp.h |    2 +-
>>   net/xdp/xsk.c               |    2 +-
>>   net/xdp/xsk_queue.h         |    3 ++-
>>   3 files changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/uapi/linux/if_xdp.h b/include/uapi/linux/if_xdp.h
>> index a78a8096f4ce..9335b56474e7 100644
>> --- a/include/uapi/linux/if_xdp.h
>> +++ b/include/uapi/linux/if_xdp.h
>> @@ -103,7 +103,7 @@ struct xdp_options {
>>   struct xdp_desc {
>>          __u64 addr;
>>          __u32 len;
>> -       __u32 options;
>> +       __u32 options; /* set to the values of xdp_hints_flags*/
>>   };
>>
>>   /* UMEM descriptor is __u64 */
>> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
>> index 5b4ce6ba1bc7..32095d78f06b 100644
>> --- a/net/xdp/xsk.c
>> +++ b/net/xdp/xsk.c
>> @@ -141,7 +141,7 @@ static int __xsk_rcv_zc(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len)
>>          int err;
>>
>>          addr = xp_get_handle(xskb);
>> -       err = xskq_prod_reserve_desc(xs->rx, addr, len);
>> +       err = xskq_prod_reserve_desc(xs->rx, addr, len, xdp->flags);
>>          if (err) {
>>                  xs->rx_queue_full++;
>>                  return err;
>> diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
>> index fb20bf7207cf..7a66f082f97e 100644
>> --- a/net/xdp/xsk_queue.h
>> +++ b/net/xdp/xsk_queue.h
>> @@ -368,7 +368,7 @@ static inline u32 xskq_prod_reserve_addr_batch(struct xsk_queue *q, struct xdp_d
>>   }
>>
>>   static inline int xskq_prod_reserve_desc(struct xsk_queue *q,
>> -                                        u64 addr, u32 len)
>> +                                        u64 addr, u32 len, u32 flags)
>>   {
>>          struct xdp_rxtx_ring *ring = (struct xdp_rxtx_ring *)q->ring;
>>          u32 idx;
>> @@ -380,6 +380,7 @@ static inline int xskq_prod_reserve_desc(struct xsk_queue *q,
>>          idx = q->cached_prod++ & q->ring_mask;
>>          ring->desc[idx].addr = addr;
>>          ring->desc[idx].len = len;
>> +       ring->desc[idx].options = flags;
>>
>>          return 0;
>>   }
>>
>>
> 

