Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38107368E98
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 10:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241583AbhDWIL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 04:11:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24706 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230525AbhDWIL5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 04:11:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619165480;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4rGme+nbimBfx5ZBGf2aqyxEqcPYa+db4cdsVsNrjKo=;
        b=FZIWtnupiSd7vE/DrrWdkrLqWrq35s+x19UgYcVbQZvnUc57qWEOYlFBscikRmMn/7yNMz
        Hpd+CPPPpi45ZvQT3kSvgYI9UExS9pWoijraGlErW3Pcy4Q3dUvBzOya8ZZ2Mp4tg+TQ3y
        qRwWqNlFyi/QsNmcd+h21wkgi7lZYF4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-550-C6FgBjeaP5-96naq9k9iZw-1; Fri, 23 Apr 2021 04:11:17 -0400
X-MC-Unique: C6FgBjeaP5-96naq9k9iZw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 38EE28030B5;
        Fri, 23 Apr 2021 08:11:15 +0000 (UTC)
Received: from [10.40.195.0] (unknown [10.40.195.0])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D727D5C541;
        Fri, 23 Apr 2021 08:11:12 +0000 (UTC)
Message-ID: <4b6e1c2e7dcece6ae45e9822d5e96f0f059691cc.camel@redhat.com>
Subject: Re: [PATCH net-next] net/sched: act_vlan: Fix vlan modify to allow
 zero priority
From:   Davide Caratti <dcaratti@redhat.com>
To:     Boris Sukholitko <boris.sukholitko@broadcom.com>,
        netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Ilya Lifshits <ilya.lifshits@broadcom.com>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>
In-Reply-To: <20210421084404.GA7262@noodle>
References: <20210421084404.GA7262@noodle>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Fri, 23 Apr 2021 10:11:11 +0200
MIME-Version: 1.0
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hello Boris, thanks for this patch!

On Wed, 2021-04-21 at 11:44 +0300, Boris Sukholitko wrote:
> Currently vlan modification action checks existance of vlan priority by
> comparing it to 0. Therefore it is impossible to modify existing vlan
> tag to have priority 0.
> 
> For example, the following tc command will change the vlan id but will
> not affect vlan priority:
> 
> tc filter add dev eth1 ingress matchall action vlan modify id 300 \
>         priority 0 pipe mirred egress redirect dev eth2
> 
> The incoming packet on eth1:
> 
> ethertype 802.1Q (0x8100), vlan 200, p 4, ethertype IPv4
> 
> will be changed to:
> 
> ethertype 802.1Q (0x8100), vlan 300, p 4, ethertype IPv4
> 
> although the user has intended to have p == 0.
> 
> The fix is to add tcfv_push_prio_exists flag to struct tcf_vlan_params
> and rely on it when deciding to set the priority.

the code looks OK to me; however maybe it's possible to do a small
improvement:

> Fixes: 45a497f2d149a4a8061c (net/sched: act_vlan: Introduce TCA_VLAN_ACT_MODIFY vlan action)
> Signed-off-by: Boris Sukholitko <boris.sukholitko@broadcom.com>
> ---
>  include/net/tc_act/tc_vlan.h | 1 +
>  net/sched/act_vlan.c         | 7 +++++--
>  2 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/include/net/tc_act/tc_vlan.h b/include/net/tc_act/tc_vlan.h
> index f051046ba034..f94b8bc26f9e 100644
> --- a/include/net/tc_act/tc_vlan.h
> +++ b/include/net/tc_act/tc_vlan.h
> @@ -16,6 +16,7 @@ struct tcf_vlan_params {
>  	u16               tcfv_push_vid;
>  	__be16            tcfv_push_proto;
>  	u8                tcfv_push_prio;
> +	bool              tcfv_push_prio_exists;

this boolean is true when the action is configured to mangle the VLAN
PCP (i.e., set it to the value stored in 'tcfv_push_prio'), and false
otherwise.
Now, when the action configuration is dumped from userspace, as follows:

# tc action show action vlan

act_vlan does the following:

302         if ((p->tcfv_action == TCA_VLAN_ACT_PUSH ||
303              p->tcfv_action == TCA_VLAN_ACT_MODIFY) &&
304             (nla_put_u16(skb, TCA_VLAN_PUSH_VLAN_ID, p->tcfv_push_vid) ||
305              nla_put_be16(skb, TCA_VLAN_PUSH_VLAN_PROTOCOL,
306                           p->tcfv_push_proto) ||
307              (nla_put_u8(skb, TCA_VLAN_PUSH_VLAN_PRIORITY,
308                                               p->tcfv_push_prio))))
309                 goto nla_put_failure;


so, userspace can't understand if this action is willing to mangle the
PCP or not, because in tcf_vlan_dump() the TCA_VLAN_PUSH_VLAN_PRIORITY
attriubute is dumped regardless of the value of 'tcfv_push_prio_exists'.

What about avoiding

 nla_put_u8(skb, TCA_VLAN_PUSH_VLAN_PRIORITY, p->tcfv_push_prio)

when 'tcfv_push_prio_exists' is false?

this would give us the advantage of making this feature (i.e., the
possibility to set the vlan priority to 0) testable using tdc
'vlan.json' (that probably needs a rescan after this patch, and a
dedicated testcase for the case where the PCP is not mangled to zero).

any feedback appreciated. Thanks!

-- 
davide

