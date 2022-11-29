Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 133D463C1D4
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 15:06:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234824AbiK2OGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 09:06:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234493AbiK2OGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 09:06:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85F6D5E3CC
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 06:05:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669730713;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kMP2ZfqViDrc1BDD3jrToKcfhnvr+kV+Y56YrH7gKXA=;
        b=Oz15HqxOanh9Uk9c6TwIlXfxgJlN9HTwSk2iLOb4RpIx1F44yZW7j+ydMI/6ZtkiqjxWAe
        zyDaYHK1xmFHntElk6QasEBbJL889ofQVLthkCy2rQ7VXgj4Gldknnet3BO55ba6c2mIMd
        cr5NgLHDhubkIOwTQ+fK2Yy4rGwgcC8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-86-QDMz9JNbOXCazGhMPaxYXw-1; Tue, 29 Nov 2022 09:05:10 -0500
X-MC-Unique: QDMz9JNbOXCazGhMPaxYXw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C4BE2833A0E;
        Tue, 29 Nov 2022 14:05:09 +0000 (UTC)
Received: from RHTPC1VM0NT (unknown [10.22.34.89])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 94F92C15BA4;
        Tue, 29 Nov 2022 14:05:09 +0000 (UTC)
From:   Aaron Conole <aconole@redhat.com>
To:     Ilya Maximets <i.maximets@ovn.org>
Cc:     Eelco Chaudron <echaudro@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>, netdev@vger.kernel.org,
        dev@openvswitch.org
Subject: Re: Patch "openvswitch: Fix Frame-size larger than 1024 bytes
 warning" not correct.
In-Reply-To: <3a98720b-4eb0-595f-81ad-f90460963c62@ovn.org> (Ilya Maximets's
        message of "Fri, 25 Nov 2022 15:53:03 +0100")
References: <9FD6F4CD-4F41-4350-B217-4EFE40E347E2@redhat.com>
        <3a98720b-4eb0-595f-81ad-f90460963c62@ovn.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
Date:   Tue, 29 Nov 2022 09:05:07 -0500
Message-ID: <f7t4juhua98.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ilya Maximets <i.maximets@ovn.org> writes:

> On 11/15/22 17:16, Eelco Chaudron wrote:
>> Hi Pravin,
>> 
>> It looks like a previous fix you made, 190aa3e77880 ("openvswitch:
>> Fix Frame-size larger than 1024 bytes warning."), is breaking
>> stuff. With this change, the actual flow lookup,
>> ovs_flow_tbl_lookup(), is done using a masked key, where it should
>> be an unmasked key. This is maybe more clear if you take a look at
>> the diff for the ufid addition, 74ed7ab9264c ("openvswitch: Add
>> support for unique flow IDs.").
>> 
>> Just reverting the change gets rid of the problem, but it will
>> re-introduce the larger stack size. It looks like we either have it
>> on the stack or dynamically allocate it each time. Let me know if
>> you have any other clever fix ;)
>
> I'd say that dynamic allocation should be fine.
> We do alloc other things in the same function, and
> I don't immediately see another simple way to fix
> the problem without heavily re-working the logic.

+1

> My 2c.
> Best regards, Ilya Maximets.
>
>> 
>> We found this after debugging some customer-specific issue. More details are in the following OVS patch, https://patchwork.ozlabs.org/project/openvswitch/list/?series=328315
>> 
>> Cheers,
>> 
>> Eelco
>> 
>> 
>> FYI the working revers:
>> 
>> 
>>    Revert "openvswitch: Fix Frame-size larger than 1024 bytes warning."
>> 
>>     This reverts commit 190aa3e77880a05332ea1ccb382a51285d57adb5.
>> 
>> diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
>> index 861dfb8daf4a..660d5fdd9b28 100644
>> --- a/net/openvswitch/datapath.c
>> +++ b/net/openvswitch/datapath.c
>> @@ -948,6 +948,7 @@ static int ovs_flow_cmd_new(struct sk_buff *skb, struct genl_info *info)
>>         struct sw_flow_mask mask;
>>         struct sk_buff *reply;
>>         struct datapath *dp;
>> +       struct sw_flow_key key;
>>         struct sw_flow_actions *acts;
>>         struct sw_flow_match match;
>>         u32 ufid_flags = ovs_nla_get_ufid_flags(a[OVS_FLOW_ATTR_UFID_FLAGS]);
>> @@ -975,24 +976,20 @@ static int ovs_flow_cmd_new(struct sk_buff *skb, struct genl_info *info)
>>         }
>> 
>>         /* Extract key. */
>> -       ovs_match_init(&match, &new_flow->key, false, &mask);
>> +       ovs_match_init(&match, &key, true, &mask);
>>         error = ovs_nla_get_match(net, &match, a[OVS_FLOW_ATTR_KEY],
>>                                   a[OVS_FLOW_ATTR_MASK], log);
>>         if (error)
>>                 goto err_kfree_flow;
>> 
>> +       ovs_flow_mask_key(&new_flow->key, &key, true, &mask);
>> +
>>         /* Extract flow identifier. */
>>         error = ovs_nla_get_identifier(&new_flow->id, a[OVS_FLOW_ATTR_UFID],
>> -                                      &new_flow->key, log);
>> +                                      &key, log);
>>         if (error)
>>                 goto err_kfree_flow;
>> 
>> -       /* unmasked key is needed to match when ufid is not used. */
>> -       if (ovs_identifier_is_key(&new_flow->id))
>> -               match.key = new_flow->id.unmasked_key;
>> -
>> -       ovs_flow_mask_key(&new_flow->key, &new_flow->key, true, &mask);
>> -
>>         /* Validate actions. */
>>         error = ovs_nla_copy_actions(net, a[OVS_FLOW_ATTR_ACTIONS],
>>                                      &new_flow->key, &acts, log);
>> @@ -1019,7 +1016,7 @@ static int ovs_flow_cmd_new(struct sk_buff *skb, struct genl_info *info)
>>         if (ovs_identifier_is_ufid(&new_flow->id))
>>                 flow = ovs_flow_tbl_lookup_ufid(&dp->table, &new_flow->id);
>>         if (!flow)
>> -               flow = ovs_flow_tbl_lookup(&dp->table, &new_flow->key);
>> +               flow = ovs_flow_tbl_lookup(&dp->table, &key);
>>         if (likely(!flow)) {
>>                 rcu_assign_pointer(new_flow->sf_acts, acts);
>> 

