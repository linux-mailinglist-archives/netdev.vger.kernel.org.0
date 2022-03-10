Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7B34D4226
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 09:05:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240178AbiCJIGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 03:06:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240184AbiCJIF7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 03:05:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 01E7A13295D
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 00:04:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646899496;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jJJEBQ+w2Vafoy7ek6WQcusu0z7dxIM3DM3nYEAv/d0=;
        b=TwSqkYQA6iWkeOodD8x//X4JvZRnVHYaFjuqtNudQTtRsBf4jI+SsiXMm7yKLi2ZFiP8dW
        866VQhDOWnF++MXReC/xoSnefxt4Ye6vTmA8+jJiM10jPJn1dqbzs3WTV0GqciKXgnii8A
        SoTdP8WaIBiqrNmrBCoXA2B62Ah6dYM=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-139-EQTplVnCMe6RsRSH95AY-g-1; Thu, 10 Mar 2022 03:04:55 -0500
X-MC-Unique: EQTplVnCMe6RsRSH95AY-g-1
Received: by mail-il1-f198.google.com with SMTP id v10-20020a92c80a000000b002c281af4ddfso2777701iln.21
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 00:04:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jJJEBQ+w2Vafoy7ek6WQcusu0z7dxIM3DM3nYEAv/d0=;
        b=4rnJJf2mFzsuTq6T9wKqSk6q5Ri+42nZfgerHSmJSpP5xLx3ULW7I3DLGOyCfRIm7m
         V7sddZXZUzS+Lf9wfFAWmwlkanTLeVFeDr5KmJO20t3ndFYp6smUaKv0LEws2L8plZSx
         fZqALjD6xp9aaFuqHXwcXZGfZZAjGeac20iSgqwW/9dl82ZJzvs8MK7q7ACzNL8bSHTY
         9dkPCKWbEQSMWFhiR47yyTYTs7pcQWqNkYa0FIK+F5SZz/2MxMqsafmY1FQSxacw4ISw
         B0cawVWLowlgnqxUvxqTIEsmJIF0aZmWFG1z76qptD2KKCYUswo5pSHtghjwaCp0oMwi
         Chsg==
X-Gm-Message-State: AOAM532D5mmWi7phA6q2sJRQQ1c6YnvHgJtb1s839ovw44L/zjmup2uW
        H/40S2jN1icc4Av6oKCjP6ERtFZoU0EfjrlpUfeoF4W8GyLPZxpD5Y//6ILkWGp5HgcxRfa+Gq+
        aerHLLaqwdViFtygB2cLR6wNw8WlF8XHm
X-Received: by 2002:a05:6e02:198c:b0:2c2:5bde:d230 with SMTP id g12-20020a056e02198c00b002c25bded230mr2622255ilf.43.1646899493751;
        Thu, 10 Mar 2022 00:04:53 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyxMTbHvONjPD3iIsh1r1QK0f5HooAWaf7InSp+UoDtmnrLwwtjjlmvH/dMJJKyD8wxJ4lZB6jGTbeHvkjjKt0=
X-Received: by 2002:a05:6e02:198c:b0:2c2:5bde:d230 with SMTP id
 g12-20020a056e02198c00b002c25bded230mr2622221ilf.43.1646899493106; Thu, 10
 Mar 2022 00:04:53 -0800 (PST)
MIME-Version: 1.0
References: <202107070458.FO35EqwU-lkp@intel.com> <CACT4ouey2QXf=PJThXG8adrLmCet4Ptu+VDDKBy2hOARqsghXQ@mail.gmail.com>
In-Reply-To: <CACT4ouey2QXf=PJThXG8adrLmCet4Ptu+VDDKBy2hOARqsghXQ@mail.gmail.com>
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date:   Thu, 10 Mar 2022 09:04:42 +0100
Message-ID: <CACT4oufM_G3YxcvcNFAPWRoQaW1mTF5bsjU-bKwDiKm3J7iijg@mail.gmail.com>
Subject: Re: drivers/net/ethernet/chelsio/cxgb4/sge.c:2571 cxgb4_ethofld_send_flowc()
 warn: missing error code 'ret'
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     kbuild@lists.01.org, lkp@intel.com, kbuild-all@lists.01.org,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 10, 2022 at 9:00 AM =C3=8D=C3=B1igo Huguet <ihuguet@redhat.com>=
 wrote:
>
> On Wed, Jul 7, 2021 at 9:37 AM Dan Carpenter <dan.carpenter@oracle.com> w=
rote:
> >
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.=
git master
> > head:   79160a603bdb51916226caf4a6616cc4e1c58a58
> > commit: 52bfcdd87e83d9e69d22da5f26b1512ffc81deed net:CXGB4: fix leak if=
 sk_buff is not used
> > config: x86_64-randconfig-m001-20210706 (attached as .config)
> > compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
> >
> > If you fix the issue, kindly add following tag as appropriate
> > Reported-by: kernel test robot <lkp@intel.com>
> > Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> >
> > New smatch warnings:
> > drivers/net/ethernet/chelsio/cxgb4/sge.c:2571 cxgb4_ethofld_send_flowc(=
) warn: missing error code 'ret'
>
> This was already reported here:
> https://lore.kernel.org/all/202107070458.FO35EqwU-lkp@intel.com/
>
> CCing again Chelsio maintainer to see if they can tell whether an
> error code is needed or not. My understanding is that it's not needed
> in this case, but not 100% sure.

I get "The message you sent to rajur@chelsio.com couldn't be delivered
due to: Recipient email address is possibly incorrect.", but that's
the email listed in MAINTAINERS.

>
> >
> > vim +/ret +2571 drivers/net/ethernet/chelsio/cxgb4/sge.c
> >
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2535  int cxgb4_ethofld_=
send_flowc(struct net_device *dev, u32 eotid, u32 tc)
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2536  {
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2537     struct port_inf=
o *pi =3D netdev2pinfo(dev);
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2538     struct adapter =
*adap =3D netdev2adap(dev);
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2539     enum sge_eosw_s=
tate next_state;
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2540     struct sge_eosw=
_txq *eosw_txq;
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2541     u32 len, len16,=
 nparams =3D 6;
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2542     struct fw_flowc=
_wr *flowc;
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2543     struct eotid_en=
try *entry;
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2544     struct sge_ofld=
_rxq *rxq;
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2545     struct sk_buff =
*skb;
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2546     int ret =3D 0;
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2547
> > a422d5ff6defb1 Gustavo A. R. Silva 2020-06-19  2548     len =3D struct_=
size(flowc, mnemval, nparams);
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2549     len16 =3D DIV_R=
OUND_UP(len, 16);
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2550
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2551     entry =3D cxgb4=
_lookup_eotid(&adap->tids, eotid);
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2552     if (!entry)
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2553             return =
-ENOMEM;
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2554
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2555     eosw_txq =3D (s=
truct sge_eosw_txq *)entry->data;
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2556     if (!eosw_txq)
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2557             return =
-ENOMEM;
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2558
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2559     skb =3D alloc_s=
kb(len, GFP_KERNEL);
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2560     if (!skb)
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2561             return =
-ENOMEM;
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2562
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2563     spin_lock_bh(&e=
osw_txq->lock);
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2564     if (tc !=3D FW_=
SCHED_CLS_NONE) {
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2565             if (eos=
w_txq->state !=3D CXGB4_EO_STATE_CLOSED)
> > 52bfcdd87e83d9 =C3=8D=C3=B1igo Huguet        2021-05-05  2566          =
           goto out_free_skb;
> >                                                                        =
 ^^^^^^^^^^^^^^^^^
> >
> > Are these error paths?
> >
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2567
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2568             next_st=
ate =3D CXGB4_EO_STATE_FLOWC_OPEN_SEND;
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2569     } else {
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2570             if (eos=
w_txq->state !=3D CXGB4_EO_STATE_ACTIVE)
> > 52bfcdd87e83d9 =C3=8D=C3=B1igo Huguet        2021-05-05 @2571          =
           goto out_free_skb;
> >
> > Here too
> >
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2572
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2573             next_st=
ate =3D CXGB4_EO_STATE_FLOWC_CLOSE_SEND;
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2574     }
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2575
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2576     flowc =3D __skb=
_put(skb, len);
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2577     memset(flowc, 0=
, len);
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2578
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2579     rxq =3D &adap->=
sge.eohw_rxq[eosw_txq->hwqid];
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2580     flowc->flowid_l=
en16 =3D cpu_to_be32(FW_WR_LEN16_V(len16) |
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2581                    =
                   FW_WR_FLOWID_V(eosw_txq->hwtid));
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2582     flowc->op_to_np=
arams =3D cpu_to_be32(FW_WR_OP_V(FW_FLOWC_WR) |
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2583                    =
                    FW_FLOWC_WR_NPARAMS_V(nparams) |
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2584                    =
                    FW_WR_COMPL_V(1));
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2585     flowc->mnemval[=
0].mnemonic =3D FW_FLOWC_MNEM_PFNVFN;
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2586     flowc->mnemval[=
0].val =3D cpu_to_be32(FW_PFVF_CMD_PFN_V(adap->pf));
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2587     flowc->mnemval[=
1].mnemonic =3D FW_FLOWC_MNEM_CH;
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2588     flowc->mnemval[=
1].val =3D cpu_to_be32(pi->tx_chan);
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2589     flowc->mnemval[=
2].mnemonic =3D FW_FLOWC_MNEM_PORT;
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2590     flowc->mnemval[=
2].val =3D cpu_to_be32(pi->tx_chan);
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2591     flowc->mnemval[=
3].mnemonic =3D FW_FLOWC_MNEM_IQID;
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2592     flowc->mnemval[=
3].val =3D cpu_to_be32(rxq->rspq.abs_id);
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2593     flowc->mnemval[=
4].mnemonic =3D FW_FLOWC_MNEM_SCHEDCLASS;
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2594     flowc->mnemval[=
4].val =3D cpu_to_be32(tc);
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2595     flowc->mnemval[=
5].mnemonic =3D FW_FLOWC_MNEM_EOSTATE;
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2596     flowc->mnemval[=
5].val =3D cpu_to_be32(tc =3D=3D FW_SCHED_CLS_NONE ?
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2597                    =
                     FW_FLOWC_MNEM_EOSTATE_CLOSING :
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2598                    =
                     FW_FLOWC_MNEM_EOSTATE_ESTABLISHED);
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2599
> > 69422a7e5d578a Rahul Lakkireddy    2020-04-30  2600     /* Free up any =
pending skbs to ensure there's room for
> > 69422a7e5d578a Rahul Lakkireddy    2020-04-30  2601      * termination =
FLOWC.
> > 69422a7e5d578a Rahul Lakkireddy    2020-04-30  2602      */
> > 69422a7e5d578a Rahul Lakkireddy    2020-04-30  2603     if (tc =3D=3D F=
W_SCHED_CLS_NONE)
> > 69422a7e5d578a Rahul Lakkireddy    2020-04-30  2604             eosw_tx=
q_flush_pending_skbs(eosw_txq);
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2605
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2606     ret =3D eosw_tx=
q_enqueue(eosw_txq, skb);
> > 52bfcdd87e83d9 =C3=8D=C3=B1igo Huguet        2021-05-05  2607     if (r=
et)
> > 52bfcdd87e83d9 =C3=8D=C3=B1igo Huguet        2021-05-05  2608          =
   goto out_free_skb;
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2609
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2610     eosw_txq->state=
 =3D next_state;
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2611     eosw_txq->flowc=
_idx =3D eosw_txq->pidx;
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2612     eosw_txq_advanc=
e(eosw_txq, 1);
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2613     ethofld_xmit(de=
v, eosw_txq);
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2614
> > 52bfcdd87e83d9 =C3=8D=C3=B1igo Huguet        2021-05-05  2615     spin_=
unlock_bh(&eosw_txq->lock);
> > 52bfcdd87e83d9 =C3=8D=C3=B1igo Huguet        2021-05-05  2616     retur=
n 0;
> > 52bfcdd87e83d9 =C3=8D=C3=B1igo Huguet        2021-05-05  2617
> > 52bfcdd87e83d9 =C3=8D=C3=B1igo Huguet        2021-05-05  2618  out_free=
_skb:
> > 52bfcdd87e83d9 =C3=8D=C3=B1igo Huguet        2021-05-05  2619     dev_c=
onsume_skb_any(skb);
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2620     spin_unlock_bh(=
&eosw_txq->lock);
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2621     return ret;
> > 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2622  }
> >
> > ---
> > 0-DAY CI Kernel Test Service, Intel Corporation
> > https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
> >
>
>
> --
> =C3=8D=C3=B1igo Huguet



--=20
=C3=8D=C3=B1igo Huguet

