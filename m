Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1A032C1492
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 20:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730532AbgKWThQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 14:37:16 -0500
Received: from linux.microsoft.com ([13.77.154.182]:43506 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730459AbgKWThQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 14:37:16 -0500
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
        by linux.microsoft.com (Postfix) with ESMTPSA id E5D4A20B7189
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 11:37:15 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E5D4A20B7189
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1606160235;
        bh=RN4Ksmh5DosGMa6xMkGkn1yRxzgPaNa2pkXkROCe8rI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=kuOQ7bnnCR6sqDlJq17LnfhHnJerUbeVVqfcKs5e8QmQKIsLeXrqCwfBLvKk02Pnz
         9F4zVDtY45v4EE6oEWZgDU1Qb0hk3sJeWa6jCF5A4BwSDxp1q6U5h3Epid/dXOzHfW
         LfyIVaHIQo222u2GxbD17s3gv9B6hc9WZkCNoLtQ=
Received: by mail-pf1-f176.google.com with SMTP id x24so3611372pfn.6
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 11:37:15 -0800 (PST)
X-Gm-Message-State: AOAM531UEKbmKfUtptYOo9KiMrCcZ1qimL+wuoMqUtlf+A9MRYAp9CTV
        +sNxe5C93hR2oiekabeFuRghiXeVb+AJcDgIQRE=
X-Google-Smtp-Source: ABdhPJyJUjIfruSk5QrFbteHs0qbukd32+qqIt5VKaFbDMpAZIJ/dgs2m6OtBK/RiZ+ROWvf1Dcgu9505xx1woxRm0Y=
X-Received: by 2002:a17:90a:fb50:: with SMTP id iq16mr485014pjb.187.1606160235427;
 Mon, 23 Nov 2020 11:37:15 -0800 (PST)
MIME-Version: 1.0
References: <160577663600.7755.4779460826621858224.stgit@wsfd-netdev64.ntdv.lab.eng.bos.redhat.com>
 <20201120131228.489c3b52@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201120131228.489c3b52@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Matteo Croce <mcroce@linux.microsoft.com>
Date:   Mon, 23 Nov 2020 20:36:39 +0100
X-Gmail-Original-Message-ID: <CAFnufp1RRtwDLwrWayvyZVPmDjab_dTx50u7xWeNwK7J6azqWw@mail.gmail.com>
Message-ID: <CAFnufp1RRtwDLwrWayvyZVPmDjab_dTx50u7xWeNwK7J6azqWw@mail.gmail.com>
Subject: Re: [PATCH net] net: openvswitch: fix TTL decrement action netlink
 message format
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eelco Chaudron <echaudro@redhat.com>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>, dev@openvswitch.org,
        Pravin B Shelar <pshelar@ovn.org>, bindiyakurle@gmail.com,
        Ilya Maximets <i.maximets@ovn.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 20, 2020 at 10:12 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 19 Nov 2020 04:04:04 -0500 Eelco Chaudron wrote:
> > Currently, the openvswitch module is not accepting the correctly formated
> > netlink message for the TTL decrement action. For both setting and getting
> > the dec_ttl action, the actions should be nested in the
> > OVS_DEC_TTL_ATTR_ACTION attribute as mentioned in the openvswitch.h uapi.
>
> IOW this change will not break any known user space, correct?
>
> But existing OvS user space already expects it to work like you
> make it work now?
>
> What's the harm in leaving it as is?
>
> > Fixes: 744676e77720 ("openvswitch: add TTL decrement action")
> > Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
>
> Can we get a review from OvS folks? Matteo looks good to you (as the
> original author)?
>

Hi,

I think that the userspace still has to implement the dec_ttl action;
by now dec_ttl is implemented with set_ttl().
So there is no breakage yet.

Eelco, with this fix we will encode the netlink attribute in the same
way for the kernel and netdev datapath?

If so, go for it.


> > -     err = __ovs_nla_copy_actions(net, attr, key, sfa, eth_type,
> > +     err = __ovs_nla_copy_actions(net, actions, key, sfa, eth_type,
> >                                    vlan_tci, mpls_label_count, log);
> >       if (err)
> >               return err;
>
> You're not canceling any nests on error, I assume this is normal.
>
> > +     add_nested_action_end(*sfa, action_start);
> >       add_nested_action_end(*sfa, start);
> >       return 0;
> >  }
>


-- 
per aspera ad upstream
