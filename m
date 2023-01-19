Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAAFF6739D2
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 14:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbjASNTU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 08:19:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230444AbjASNTI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 08:19:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24B0D75705
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 05:18:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674134297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=viwsXFX0qFE1Cx1DFBWUF5CQ64d9VMHm+O5wbgL/j7Y=;
        b=AdVl8A03xclsBdHtL5F7KPX9VD1Eut8mOBWG+S4mYMkXzvtihg7884eo+myQ1PkRkNjFkN
        1H+8wetJTXRM15R8fSZrr7MBNOm2NSd9m1gTY7l39x8WSMevOa193WB7D54DeuVt8T54G0
        u3zoyd5fxpCvtSzLgO8boQS/p3Dkgxo=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-269-RrYU2eIdNUC00xuFwvatBw-1; Thu, 19 Jan 2023 08:18:15 -0500
X-MC-Unique: RrYU2eIdNUC00xuFwvatBw-1
Received: by mail-ed1-f72.google.com with SMTP id z2-20020a056402274200b0049e48d86760so1608653edd.4
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 05:18:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=viwsXFX0qFE1Cx1DFBWUF5CQ64d9VMHm+O5wbgL/j7Y=;
        b=L549Aogk9rNSm/V2MG5kECFtTrSOVsocvSsZhKYHjx347oBkDYAF3siwOu4RCX09KS
         tz9+CHen8JyusvkYspMUj/4BvOdYXgycf3GOwREdq2RDMg3kruP5CsPLGh7XV0p1DzzC
         lXeClb8r5fYjJfnrrB8ONz4hehkW4oeI8MzfTE8BHQvd3OiQCMz2ph7VtTUrivC87wNk
         3gfdvcYQnz8mf6Nxr6XLjEWEWXQTGboNnVDM9JA6T1f6z/+m61SWgDSffExbqKzpVSbV
         wFJYUsB5VYkNXqBijh6QVlSTaD1yVkLa5eJ/xvZt/PxxMGMvQdZZB4Lt3n+Gad9tZ8vc
         Fjcw==
X-Gm-Message-State: AFqh2krWUo2xoC3PcGhySjXRE1smAlAdQ0eyN3K4gcSqAN1fTYPddRVE
        fM5ddlDdrnH7OLjMp1zCnWaKqAdi7J9gx6wtwAh53gatTXvll1ynAp0Zlw7iPKdw+UjK/Tha1iW
        li5stTqu5wvnta97n
X-Received: by 2002:a17:906:9710:b0:7c1:e7a:62e6 with SMTP id k16-20020a170906971000b007c10e7a62e6mr12200354ejx.71.1674134294586;
        Thu, 19 Jan 2023 05:18:14 -0800 (PST)
X-Google-Smtp-Source: AMrXdXumjLwpT+oQT2/h5PjABGRHHhMPxBBMP3kdZQzGA+cb8mxrvoHG62ZCGMwApVGdxI7STzZ9dw==
X-Received: by 2002:a17:906:9710:b0:7c1:e7a:62e6 with SMTP id k16-20020a170906971000b007c10e7a62e6mr12200332ejx.71.1674134294294;
        Thu, 19 Jan 2023 05:18:14 -0800 (PST)
Received: from [192.168.41.200] (83-90-141-187-cable.dk.customer.tdc.net. [83.90.141.187])
        by smtp.gmail.com with ESMTPSA id ks1-20020a170906f84100b00877696c016csm1501559ejb.146.2023.01.19.05.18.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Jan 2023 05:18:13 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <eb5601d0-2c95-4485-31b2-e5cb5ff3037c@redhat.com>
Date:   Thu, 19 Jan 2023 14:18:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Cc:     brouer@redhat.com, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        pabeni@redhat.com
Subject: Re: [PATCH net-next V2 2/2] net: kfree_skb_list use
 kmem_cache_free_bulk
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
References: <167361788585.531803.686364041841425360.stgit@firesoul>
 <167361792462.531803.224198635706602340.stgit@firesoul>
 <6f634864-2937-6e32-ba9d-7fa7f2b576cb@redhat.com>
 <20230118182600.026c8421@kernel.org>
 <e564a0de-e149-34a0-c0ba-8f740df0ae70@redhat.com>
 <CANn89iJPm30ur1_tE6TPU-QYDGqszavhtm0vLt2MyK90MYFA3A@mail.gmail.com>
 <d0ecbed5-0588-9624-7ecb-014a3bebf192@redhat.com>
 <CANn89iLymg62A8GNy4jJ3tsyitNZvDnhbA90t4ZJQ2dX=RG2qw@mail.gmail.com>
In-Reply-To: <CANn89iLymg62A8GNy4jJ3tsyitNZvDnhbA90t4ZJQ2dX=RG2qw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 19/01/2023 12.46, Eric Dumazet wrote:
> On Thu, Jan 19, 2023 at 12:22 PM Jesper Dangaard Brouer
> <jbrouer@redhat.com> wrote:
>>
>>
>>
>> On 19/01/2023 11.28, Eric Dumazet wrote:
>>> On Thu, Jan 19, 2023 at 11:18 AM Jesper Dangaard Brouer
>>> <jbrouer@redhat.com> wrote:
>>>>
>>>>
>>>>
>>>> On 19/01/2023 03.26, Jakub Kicinski wrote:
>>>>> On Wed, 18 Jan 2023 22:37:47 +0100 Jesper Dangaard Brouer wrote:
>>>>>>> +           skb_mark_not_on_list(segs);
>>>>>>
>>>>>> The syzbot[1] bug goes way if I remove this skb_mark_not_on_list().
>>>>>>
>>>>>> I don't understand why I cannot clear skb->next here?
>>>>>
>>>>> Some of the skbs on the list are not private?
>>>>> IOW we should only unlink them if skb_unref().
>>>>
>>>> Yes, you are right.
>>>>
>>>> The skb_mark_not_on_list() should only be called if __kfree_skb_reason()
>>>> returns true, meaning the SKB is ready to be free'ed (as it calls/check
>>>> skb_unref()).
>>>
>>>
>>> This was the case already before your changes.
>>>
>>> skb->next/prev can not be shared by multiple users.
>>>
>>> One skb can be put on a single list by definition.
>>>
>>> Whoever calls kfree_skb_list(list) owns all the skbs->next|prev found
>>> in the list
>>>
>>> So you can mangle skb->next as you like, even if the unref() is
>>> telling that someone
>>> else has a reference on skb.
>>
>> Then why does the bug go way if I remove the skb_mark_not_on_list() call
>> then?
>>
> 
> Some side effects.
> 
> This _particular_ repro uses a specific pattern that might be defeated
> by a small change.
> (just working around another bug)
> 
> Instead of setting skb->next to NULL, try to set it to
> 
> skb->next = (struct sk_buff *)0x800;
> 
> This might show a different pattern.

Nice trick, I'll use this next time.

I modified to code and added a kfree_skb tracepoint with a known reason
(PROTO_MEM) to capture the callstack. See end of email.  Which shows
multicast code path is involved.

  trace_kfree_skb(segs, __builtin_return_address(0), 
SKB_DROP_REASON_PROTO_MEM);

>>>>
>>>> I will send a proper fix patch shortly... after syzbot do a test on it.
>>>>
>>
>> I've send a patch for syzbot that only calls skb_mark_not_on_list() when
>> unref() and __kfree_skb_reason() "permits" this.
>> I tested it locally with reproducer and it also fixes/"removes" the bug.
> 
> This does not mean we will accept a patch with no clear explanation
> other than "this removes a syzbot bug, so this must be good"
> 
> Make sure to give precise details on _why_ this is needed or not.
> 
> Again, the user of kfree_skb_list(list) _owns_ skb->next for sure.
> If you think this assertion is not true, we are in big trouble.
> 

I think I have found an explanation, why/when refcnt can be elevated on
an SKB-list.  The skb_shinfo(skb)->flag_list can increase refcnt.

See code:
  static void skb_clone_fraglist(struct sk_buff *skb)
  {
	struct sk_buff *list;

	skb_walk_frags(skb, list)
		skb_get(list);
  }

This walks the SKBs on the shinfo->frag_list and increase the refcnt
(skb->users).

Notice that kfree_skb_list is also called when freeing the SKBs
"frag_list" in skb_release_data().

IMHO this explains why we can only remove the SKB from the list, when
"permitted" by skb_unref(), e.g. if __kfree_skb_reason() returns true.

--Jesper


Call-stack of case with elevated refcnt when walking SKB-list:
--------------------------------------------------------------

repro  3048 [003]   101.689670: skb:kfree_skb: 
skbaddr=0xffff888104086600 protocol=0 
location=skb_release_data.cold+0x25 reason: PROTO_MEM
         ffffffff81bb6448 kfree_skb_list_reason.cold+0x3b 
(/boot/vmlinux-6.2.0-rc3-net-next-kfunc-xdp-hints+)
         ffffffff81bb6448 kfree_skb_list_reason.cold+0x3b 
(/boot/vmlinux-6.2.0-rc3-net-next-kfunc-xdp-hints+)
         ffffffff81bb6484 skb_release_data.cold+0x25 
(/boot/vmlinux-6.2.0-rc3-net-next-kfunc-xdp-hints+)
         ffffffff819137e1 kfree_skb_reason+0x41 
(/boot/vmlinux-6.2.0-rc3-net-next-kfunc-xdp-hints+)
         ffffffff81a1e246 igmp_rcv+0xf6 
(/boot/vmlinux-6.2.0-rc3-net-next-kfunc-xdp-hints+)
         ffffffff819c5e85 ip_protocol_deliver_rcu+0x165 
(/boot/vmlinux-6.2.0-rc3-net-next-kfunc-xdp-hints+)
         ffffffff819c5f12 ip_local_deliver_finish+0x72 
(/boot/vmlinux-6.2.0-rc3-net-next-kfunc-xdp-hints+)
         ffffffff81930b89 __netif_receive_skb_one_core+0x69 
(/boot/vmlinux-6.2.0-rc3-net-next-kfunc-xdp-hints+)
         ffffffff81930e31 process_backlog+0x91 
(/boot/vmlinux-6.2.0-rc3-net-next-kfunc-xdp-hints+)
         ffffffff8193197b __napi_poll+0x2b 
(/boot/vmlinux-6.2.0-rc3-net-next-kfunc-xdp-hints+)
         ffffffff81931e86 net_rx_action+0x276 
(/boot/vmlinux-6.2.0-rc3-net-next-kfunc-xdp-hints+)
         ffffffff81bcf083 __do_softirq+0xd3 
(/boot/vmlinux-6.2.0-rc3-net-next-kfunc-xdp-hints+)
         ffffffff81087243 do_softirq+0x63 
(/boot/vmlinux-6.2.0-rc3-net-next-kfunc-xdp-hints+)
         ffffffff810872e4 __local_bh_enable_ip+0x64 
(/boot/vmlinux-6.2.0-rc3-net-next-kfunc-xdp-hints+)
         ffffffff8192ba8f netif_rx+0xdf 
(/boot/vmlinux-6.2.0-rc3-net-next-kfunc-xdp-hints+)
         ffffffff8192bb27 dev_loopback_xmit+0x77 
(/boot/vmlinux-6.2.0-rc3-net-next-kfunc-xdp-hints+)
         ffffffff819c9195 ip_mc_finish_output+0x65 
(/boot/vmlinux-6.2.0-rc3-net-next-kfunc-xdp-hints+)
         ffffffff819cc597 ip_mc_output+0x137 
(/boot/vmlinux-6.2.0-rc3-net-next-kfunc-xdp-hints+)
         ffffffff819cd2b8 ip_push_pending_frames+0xa8 
(/boot/vmlinux-6.2.0-rc3-net-next-kfunc-xdp-hints+)
         ffffffff81a04f67 raw_sendmsg+0x607 
(/boot/vmlinux-6.2.0-rc3-net-next-kfunc-xdp-hints+)
         ffffffff8190153b sock_sendmsg+0x8b 
(/boot/vmlinux-6.2.0-rc3-net-next-kfunc-xdp-hints+)
         ffffffff8190323b __sys_sendto+0xeb 
(/boot/vmlinux-6.2.0-rc3-net-next-kfunc-xdp-hints+)
         ffffffff819032b0 __x64_sys_sendto+0x20 
(/boot/vmlinux-6.2.0-rc3-net-next-kfunc-xdp-hints+)
         ffffffff81bb9ffa do_syscall_64+0x3a 
(/boot/vmlinux-6.2.0-rc3-net-next-kfunc-xdp-hints+)
         ffffffff81c000aa entry_SYSCALL_64+0xaa 
(/boot/vmlinux-6.2.0-rc3-net-next-kfunc-xdp-hints+)
                   10af3d syscall+0x1d (/usr/lib64/libc.so.6)
                     46d3 do_sandbox_none+0x81 
(/home/jbrouer/syzbot-kfree_skb_list/repro)
                     48ce main+0xa5 
(/home/jbrouer/syzbot-kfree_skb_list/repro)
                    29550 __libc_start_call_main+0x80 (/usr/lib64/libc.so.6)




Resolving some symbols:

ip_mc_finish_output+0x65
------------------------
[net-next]$ ./scripts/faddr2line net/ipv4/ip_output.o 
ip_mc_finish_output+0x65
ip_mc_finish_output+0x65/0x190:
ip_mc_finish_output at net/ipv4/ip_output.c:356

ip_mc_output+0x137
------------------
[net-next]$ ./scripts/faddr2line vmlinux ip_mc_output+0x137
ip_mc_output+0x137/0x2a0:
skb_network_header at include/linux/skbuff.h:2829
(inlined by) ip_hdr at include/linux/ip.h:21
(inlined by) ip_mc_output at net/ipv4/ip_output.c:401

igmp_rcv+0xf6
-------------
[net-next]$ ./scripts/faddr2line vmlinux igmp_rcv+0xf6
igmp_rcv+0xf6/0x2e0:
igmp_rcv at net/ipv4/igmp.c:1130

