Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAE045A000E
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 19:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239832AbiHXRGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 13:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239828AbiHXRGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 13:06:51 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D56B979A6B;
        Wed, 24 Aug 2022 10:06:47 -0700 (PDT)
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1oQtpp-000B4w-Nl; Wed, 24 Aug 2022 19:06:33 +0200
Received: from [85.1.206.226] (helo=linux-4.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1oQtpp-000THk-CK; Wed, 24 Aug 2022 19:06:33 +0200
Subject: Re: [PATCH ipsec-next 2/3] xfrm: interface: support collect metadata
 mode
To:     Eyal Birger <eyal.birger@gmail.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        pablo@netfilter.org, contact@proelbtn.com, dsahern@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, devel@linux-ipsec.org
References: <20220823154557.1400380-1-eyal.birger@gmail.com>
 <20220823154557.1400380-3-eyal.birger@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <6477c6e6-cb01-eaa3-3e3e-b0f796fd08c2@iogearbox.net>
Date:   Wed, 24 Aug 2022 19:06:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220823154557.1400380-3-eyal.birger@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26637/Wed Aug 24 09:53:01 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eyal,

On 8/23/22 5:45 PM, Eyal Birger wrote:
> This commit adds support for 'collect_md' mode on xfrm interfaces.
> 
> Each net can have one collect_md device, created by providing the
> IFLA_XFRM_COLLECT_METADATA flag at creation. This device cannot be
> altered and has no if_id or link device attributes.
> 
> On transmit to this device, the if_id is fetched from the attached dst
> metadata on the skb. The dst metadata type used is METADATA_XFRM
> which holds the if_id property.
> 
> On the receive side, xfrmi_rcv_cb() populates a dst metadata for each
> packet received and attaches it to the skb. The if_id used in this case is
> fetched from the xfrm state. This can later be used by upper layers such
> as tc, ebpf, and ip rules.
> 
> Because the skb is scrubed in xfrmi_rcv_cb(), the attachment of the dst
> metadata is postponed until after scrubing. Similarly, xfrm_input() is
> adapted to avoid dropping metadata dsts by only dropping 'valid'
> (skb_valid_dst(skb) == true) dsts.
> 
> Policy matching on packets arriving from collect_md xfrmi devices is
> done by using the xfrm state existing in the skb's sec_path.
> The xfrm_if_cb.decode_cb() interface implemented by xfrmi_decode_session()
> is changed to keep the details of the if_id extraction tucked away
> in xfrm_interface.c.
> 
> Signed-off-by: Eyal Birger <eyal.birger@gmail.com>

Can be done in follow-up (once merged back from net-next into bpf-next),
but it would be nice to also have a BPF CI selftest for it to make sure
the ipsec+collect_md with BPF is consistently tested for incoming patches.

Thanks,
Daniel
