Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06AA5690C5B
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 16:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbjBIPCR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 10:02:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbjBIPCQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 10:02:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BCB122035
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 07:01:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675954893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mqFnMsHKksUP5HuvOqphI436gZqoaofNS/oLBgKoMdY=;
        b=XIrF57Bb7tTQcVbPEMBCWoetxwmlvDa77ignQ8faB5N7u3PYYk8l6TVqBZw/oUMaahpYwq
        70b0XHNm08cWpCR7iqjNxsMNCbq38pHoUGsZtNKu9un141bkK6Wniqrf9/lWk0vSZLvlqG
        nTAMNum34sXqwCtQw7m3pYa+Apy/Zak=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-643-Nby1LoQdP26Sshuc34WxOw-1; Thu, 09 Feb 2023 10:01:29 -0500
X-MC-Unique: Nby1LoQdP26Sshuc34WxOw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A232D3C0E45B;
        Thu,  9 Feb 2023 15:01:23 +0000 (UTC)
Received: from RHTPC1VM0NT (unknown [10.22.18.173])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D55FA2026D4B;
        Thu,  9 Feb 2023 15:01:22 +0000 (UTC)
From:   Aaron Conole <aconole@redhat.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org,
        davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>
Subject: Re: [PATCHv2 net-next 3/5] openvswitch: move key and ovs_cb update
 out of handle_fragments
References: <cover.1675810210.git.lucien.xin@gmail.com>
        <d7a2bbc1b84729d619f20446b51ab461b788adb6.1675810210.git.lucien.xin@gmail.com>
Date:   Thu, 09 Feb 2023 10:01:22 -0500
In-Reply-To: <d7a2bbc1b84729d619f20446b51ab461b788adb6.1675810210.git.lucien.xin@gmail.com>
        (Xin Long's message of "Tue, 7 Feb 2023 17:52:08 -0500")
Message-ID: <f7tzg9mg9x9.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xin Long <lucien.xin@gmail.com> writes:

> This patch has no functional changes and just moves key and ovs_cb update
> out of handle_fragments, and skb_clear_hash() and skb->ignore_df change
> into handle_fragments(), to make it easier to move the duplicate code
> from handle_fragments() into nf_conntrack_ovs later.
>
> Note that it changes to pass info->family to handle_fragments() instead
> of key for the packet type check, as info->family is set according to
> key->eth.type in ovs_ct_copy_action() when creating the action.
>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---

Reviewed-by: Aaron Conole <aconole@redhat.com>

