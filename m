Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2B7177472
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 11:45:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728713AbgCCKpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 05:45:36 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:36549 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728572AbgCCKpg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 05:45:36 -0500
Received: by mail-qt1-f194.google.com with SMTP id t13so2425579qto.3
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 02:45:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=eKwgsoOK7imonvQsdesRpH5RTB010MjzjujLgQjJXos=;
        b=lo5sBuQakBnPEc+3yHuduGplDTQTKjQF/sa+v02KHNMp/RI198q42japxuXAXLWX4E
         sip5ncTn2gGp6yS/PTufWuNb8ASsfjUut/rjR9hWVp8XlPr1XnZCEip7VFQbuh/TKTwB
         bBnpMjSPJ3vdKRHYe3YB7oGGQbrM21ajBslNHoVRDISS8vQUF3yej4LgunRW44boGeX0
         MtkWX6FDfeV7IfTgbwo9wDb3AiMPG3D+nrt5j/CVUqX8urp0Kk/2h4+jN5vANrIHSaTb
         WOph7s5FYGixBejNMNhUNsge0e8HYvZAwR8YjCMCzTFXshhFfNV3iWGo0SkMvcKwzxmm
         sLpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=eKwgsoOK7imonvQsdesRpH5RTB010MjzjujLgQjJXos=;
        b=hAKpXit1/ysg9yug3a4iJVi4bfNWj9UlksGnRNGiGsYY6Eltlj14/zlSX1ynNWXTtY
         G35U7wbkKKM6LD5WYWSb7tukBpHHFmKtPTjoTCCK7uCKlNJ6CzgKkMTyxiWsROToXwml
         9PsjEA0/v4AV4NMFvUjlTdbt8Yf4u7moWO8iEX1ZVBvcSOtD1kDeY3mZ18Ee9E5iiboL
         XUDTWwg7x3y9hhWooff1fD+vnJhZ+igzymktxAi8YoXSvJ3SEKqHxO7A/yzuPPpMObjX
         9BGp/QotQFfzwUWExJySnPCY1icqBpgl1wJWUFVzOdjcE2vxzmUVwpAnra/GxfOQrOzg
         Um9A==
X-Gm-Message-State: ANhLgQ06MVmSoQYrFY1PuPdVCkjOJFlVff5ULSH8lvPciTiFKyToJ6IP
        kN5vtQcwkT7wQjF9auVwBlzipVIarxpJjCsdSNpz/zI0
X-Google-Smtp-Source: ADFU+vvg+eSTBK//qZC4G6ppv3DFv23E2Hzu3LukZaKqKC+/wxmQr2Kj3oxfRJjE4xhPyfs1YCkWv8SUBRrC5/zpeA4=
X-Received: by 2002:ac8:3823:: with SMTP id q32mr3963106qtb.340.1583232335350;
 Tue, 03 Mar 2020 02:45:35 -0800 (PST)
MIME-Version: 1.0
From:   Wim Daelemans <wim.daelemans.vger@gmail.com>
Date:   Tue, 3 Mar 2020 11:45:24 +0100
Message-ID: <CALOn_NyosRuyvvFT-kSu6kTdz052_Cz-pxFPc2xxU0ChrbDPgw@mail.gmail.com>
Subject: RCU-based synchronization in Linux 802.1Q VLAN code
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

* Problem

I am studying RCU-usage in the Linux 4.14.171 kernel, and more
specifically in the 802.1Q VLAN code.
(and after having read the excellent article of Paul McKenney on lwn.net)

One of the RCU-protected structures is "struct vlan_info".
Although I am not a specialist in this subject, I think the updating
of this object is not completely safe for its readers (but maybe I am
missing something).  Could somebody please enlighten me?

* Object creation

At object creation time the RCU principles are correctly applied:  The
newly created object is invisible to readers until it is finally
published (in vlan_core.c):

>  vlan_vid_add() {
>    //...
>    rcu_assign_pointer(dev->vlan_info, vlan_info);
>    // ...
>  }

* Subsequent updates on pre-existing vlan_info

Whenever this vlan_info object (or any of its members) gets updated at
a later point in time, I would expect the following steps:
- Make a copy (new version)
- Update the copy
- Atomically replace the old version with the new version
However it seems the vlan_info object (or any of its members) is just
updated in place, without protection against possible reordering of
memory operations and potential concurrent readers seeing an
inconsistent state of the object.

To give you one example (although perhaps not the best one):
vlan_newlink() --> register_vlan_dev() --> vlan_group_prealloc_vid():

>  static int vlan_group_prealloc_vid(struct vlan_group *vg, __be16 vlan_proto, u16 vlan_id)
>  {
>    // ...
>    array = kzalloc(size, GFP_KERNEL);
>    // ...
>    vg->vlan_devices_arrays[pidx][vidx] = array; // (*)
>    return 0;
>  }

In theory the compiler or even the CPU could decide to postpone the
zeroing out of the new memory (by kzalloc) until after the pointer
storage (*).  In between the memory could still be uninitialized
(containing invalid pointers).  However the new array will already be
accessible to potential readers.

Imagine packets for this VID already coming in during this process.
There is nothing preventing the read sections for already accessing
this new array during this process:

netif_receive_skb_internal() --> vlan_do_receive() --> vlan_find_dev()
--> __vlan_group_get_device():

>  static inline struct net_device *__vlan_group_get_device(struct vlan_group *vg,
>                             unsigned int pidx,
>                             u16 vlan_id)
>  {
>    struct net_device **array;
>    array = vg->vlan_devices_arrays[pidx]
>                       [vlan_id / VLAN_GROUP_ARRAY_PART_LEN];
>    return array ? array[vlan_id % VLAN_GROUP_ARRAY_PART_LEN] : NULL;
>  }

I know that sometimes you get memory barriers for free (for instance
when the compiler takes in an unknown function it will add memory
barriers before and after).  But we should not rely on these things?

Another example:  One of vlan_info's members is a linked list
(vid_list).  Modifications to this list are using plain "list_add()"
instead of "list_add_rcu()".

Many thanks in advance for your view on this.
With kind regards,
Wim Daelemans
