Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4C5AA9A3
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 19:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387911AbfIEREY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 13:04:24 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34369 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730864AbfIEREY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 13:04:24 -0400
Received: by mail-pg1-f193.google.com with SMTP id n9so1762481pgc.1;
        Thu, 05 Sep 2019 10:04:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pY9aJUcggotSUrIOovI87Hz1WVVyhaxl425ZRHuP5KA=;
        b=M7j3tgl/DUrxolbocw8AmEU/2jghfXhspIIzrMqBJDXGYRNcGddstjqjqa4AB6OOBc
         xijRyCGrz8+elOC5lJd3AywF/DrJBpQlhvPFzuQAwSGur2h9/zL5p2Ty7HGJELB6PuYS
         74WnZpcsURHJCl+7iwbrvTavhwsp5WQC0McoueVZtl7hg4LT/8SXizn2s01KIAKRZSt4
         RJgQyO618mlUfdGgGxAtVn9o6K0c7EByl+WcUawyYb+XCpQocMQNLSatAM54dGah2zno
         WE2xP1wA9Nhi3KBfvesWNnWLuajpeavTa88qTmTWNuftO7wvrZjgZ+gtE+rOXheksEsj
         mjVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pY9aJUcggotSUrIOovI87Hz1WVVyhaxl425ZRHuP5KA=;
        b=fAwGERSu9WBP48KHzdejG7uGUzITAnfl5ID05vhEK8bxJvow2bmUTLCnymhfGVIEis
         SXLDdrUf2OMq3gSLgLJUvPeMgQUWsgbUQBdi+Eoj93Kt9JUDbkzDCduOnQ7DJIji7aRX
         EHv23oGgLk/oMDLJtqNWP9WMdCpRXWFiN8ReoKYpAob+yhlJUSK4mHdvBty0DX9JqDoa
         Ndqgw98EGs4vsEOf9+NpI1NQUykekTRQINC5oc0VUEcZdFWm/27SMA75Uxs7aDv92oqB
         7i6kSfl7FqEhsTbJYkt9MZJhzrfdlDewwTUePuM/FgQ18QiZLhjhkl555+V3vA5EMSL2
         sP/w==
X-Gm-Message-State: APjAAAXH3v/5DP2JXH8d0QyQha1l3Mtf5Qfw23Dp9JeazKgyFYT+N87t
        PTVqMrIVJ1AZJAfhM7kTxUWg9AjCFda2Lcm+J80=
X-Google-Smtp-Source: APXvYqxCeE/2a4yXh06uzY/UB2tuXby2Gi0P58Q0SuOOPej3LxttTYy+aCrxSc4+BuW1wDetFYErqk9Tc7I5vB40bVQ=
X-Received: by 2002:a63:5811:: with SMTP id m17mr4129200pgb.237.1567703063289;
 Thu, 05 Sep 2019 10:04:23 -0700 (PDT)
MIME-Version: 1.0
References: <1567609423-26826-1-git-send-email-zdai@linux.vnet.ibm.com>
In-Reply-To: <1567609423-26826-1-git-send-email-zdai@linux.vnet.ibm.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 5 Sep 2019 10:04:12 -0700
Message-ID: <CAM_iQpW_x6bN1Ea1sGv4XpNauXEpu+fKOhoW6350ztYF5izhGg@mail.gmail.com>
Subject: Re: [v3] net_sched: act_police: add 2 new attributes to support
 police 64bit rate and peakrate
To:     David Dai <zdai@linux.vnet.ibm.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, zdai@us.ibm.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 4, 2019 at 8:03 AM David Dai <zdai@linux.vnet.ibm.com> wrote:
>
> For high speed adapter like Mellanox CX-5 card, it can reach upto
> 100 Gbits per second bandwidth. Currently htb already supports 64bit rate
> in tc utility. However police action rate and peakrate are still limited
> to 32bit value (upto 32 Gbits per second). Add 2 new attributes
> TCA_POLICE_RATE64 and TCA_POLICE_RATE64 in kernel for 64bit support
> so that tc utility can use them for 64bit rate and peakrate value to
> break the 32bit limit, and still keep the backward binary compatibility.
>
> Tested-by: David Dai <zdai@linux.vnet.ibm.com>
> Signed-off-by: David Dai <zdai@linux.vnet.ibm.com>

Acked-by: Cong Wang <xiyou.wangcong@gmail.com>

Thanks.
