Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C60DA4DC83E
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 15:02:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234885AbiCQODZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 10:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235089AbiCQODA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 10:03:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 95BFE1C1EEF
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 07:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647525703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BwfYaaZT/DEIGkMAHoUiZty2BgUuPwkgnbyUH7oMrOQ=;
        b=FjZO9WPspSbP18abDnjk29PJrTcU1HyNMwg58PhEgvvUwyeCeByBLYtGYR9TdWgS8kWEu+
        3WipXQoIOEh/SAFU+UvjF6swwOVwK9K+3XK7cgsDBfSKEbE5YiI+BsW+hP8xTvCJXKiATN
        J7qw8QwqN9XUbVnmbpeburSVm0XQRGk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-481-Dt9WYfy1P3-NWbqZLlcFaw-1; Thu, 17 Mar 2022 10:01:40 -0400
X-MC-Unique: Dt9WYfy1P3-NWbqZLlcFaw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0B15D3800E8F;
        Thu, 17 Mar 2022 14:01:40 +0000 (UTC)
Received: from RHTPC1VM0NT (unknown [10.22.17.112])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C132141136E2;
        Thu, 17 Mar 2022 14:01:39 +0000 (UTC)
From:   Aaron Conole <aconole@redhat.com>
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Dumitru Ceara <dceara@redhat.com>,
        Ilya Maximets <i.maximets@ovn.org>
Subject: Re: [ovs-dev] [PATCH net] openvswitch: always update flow key after
 NAT
References: <20220317121729.2810292-1-aconole@redhat.com>
        <E3DEE4BD-F8BB-4B41-8310-9214B1431614@redhat.com>
Date:   Thu, 17 Mar 2022 10:01:39 -0400
In-Reply-To: <E3DEE4BD-F8BB-4B41-8310-9214B1431614@redhat.com> (Eelco
        Chaudron's message of "Thu, 17 Mar 2022 14:42:33 +0100")
Message-ID: <f7t1qz0he4c.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eelco Chaudron <echaudro@redhat.com> writes:

> On 17 Mar 2022, at 13:17, Aaron Conole wrote:
>
>> During NAT, a tuple collision may occur.  When this happens, openvswitch
>> will make a second pass through NAT which will perform additional packet
>> modification.  This will update the skb data, but not the flow key that
>> OVS uses.  This means that future flow lookups, and packet matches will
>> have incorrect data.  This has been supported since
>> commit 5d50aa83e2c8 ("openvswitch: support asymmetric conntrack").
>>
>> That commit failed to properly update the sw_flow_key attributes, since
>> it only called the ovs_ct_nat_update_key once, rather than each time
>> ovs_ct_nat_execute was called.  As these two operations are linked, the
>> ovs_ct_nat_execute() function should always make sure that the
>> sw_flow_key is updated after a successful call through NAT infrastructur=
e.
>>
>> Fixes: 5d50aa83e2c8 ("openvswitch: support asymmetric conntrack")
>> Cc: Dumitru Ceara <dceara@redhat.com>
>> Cc: Numan Siddique <nusiddiq@redhat.com>
>> Signed-off-by: Aaron Conole <aconole@redhat.com>
>> ---
>>  net/openvswitch/conntrack.c | 20 ++++++++++++--------
>>  1 file changed, 12 insertions(+), 8 deletions(-)
>>
>> diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
>> index c07afff57dd3..461dbb3b7090 100644
>> --- a/net/openvswitch/conntrack.c
>> +++ b/net/openvswitch/conntrack.c
>> @@ -104,6 +104,10 @@ static bool labels_nonzero(const struct ovs_key_ct_=
labels *labels);
>>
>>  static void __ovs_ct_free_action(struct ovs_conntrack_info *ct_info);
>>
>> +static void ovs_nat_update_key(struct sw_flow_key *key,
>> +			       const struct sk_buff *skb,
>> +			       enum nf_nat_manip_type maniptype);
>> +
>
> nit?: Rather than adding this would it be simpler to swap the order of
> ovs_nat_update_key and ovs_ct_nat_execute?

I thought it looked messier that way.

> Also, the function is defined by =E2=80=9C#if IS_ENABLED(CONFIG_NF_NAT)=
=E2=80=9D not
> sure if this will generate warnings if the function is not present?

Good catch, yes it will.  I will submit a v2 with this guard in place if
you think the foward decl is okay to keep.

>>  static u16 key_to_nfproto(const struct sw_flow_key *key)
>>  {
>>  	switch (ntohs(key->eth.type)) {
>> @@ -741,7 +745,7 @@ static bool skb_nfct_cached(struct net *net,
>>  static int ovs_ct_nat_execute(struct sk_buff *skb, struct nf_conn *ct,
>>  			      enum ip_conntrack_info ctinfo,
>>  			      const struct nf_nat_range2 *range,
>> -			      enum nf_nat_manip_type maniptype)
>> +			      enum nf_nat_manip_type maniptype, struct sw_flow_key *key)
>>  {
>>  	int hooknum, nh_off, err =3D NF_ACCEPT;
>>
>> @@ -813,6 +817,10 @@ static int ovs_ct_nat_execute(struct sk_buff *skb, =
struct nf_conn *ct,
>>  push:
>>  	skb_push_rcsum(skb, nh_off);
>>
>> +	/* Update the flow key if NAT successful. */
>> +	if (err =3D=3D NF_ACCEPT)
>> +		ovs_nat_update_key(key, skb, maniptype);
>> +
>>  	return err;
>>  }
>>
>> @@ -906,7 +914,7 @@ static int ovs_ct_nat(struct net *net, struct sw_flo=
w_key *key,
>>  	} else {
>>  		return NF_ACCEPT; /* Connection is not NATed. */
>>  	}
>> -	err =3D ovs_ct_nat_execute(skb, ct, ctinfo, &info->range, maniptype);
>> +	err =3D ovs_ct_nat_execute(skb, ct, ctinfo, &info->range, maniptype, k=
ey);
>>
>>  	if (err =3D=3D NF_ACCEPT && ct->status & IPS_DST_NAT) {
>>  		if (ct->status & IPS_SRC_NAT) {
>> @@ -916,17 +924,13 @@ static int ovs_ct_nat(struct net *net, struct sw_f=
low_key *key,
>>  				maniptype =3D NF_NAT_MANIP_SRC;
>>
>>  			err =3D ovs_ct_nat_execute(skb, ct, ctinfo, &info->range,
>> -						 maniptype);
>> +						 maniptype, key);
>>  		} else if (CTINFO2DIR(ctinfo) =3D=3D IP_CT_DIR_ORIGINAL) {
>>  			err =3D ovs_ct_nat_execute(skb, ct, ctinfo, NULL,
>> -						 NF_NAT_MANIP_SRC);
>> +						 NF_NAT_MANIP_SRC, key);
>>  		}
>>  	}
>>
>> -	/* Mark NAT done if successful and update the flow key. */
>> -	if (err =3D=3D NF_ACCEPT)
>> -		ovs_nat_update_key(key, skb, maniptype);
>> -
>>  	return err;
>>  }
>>  #else /* !CONFIG_NF_NAT */
>
> The rest of the patch looks fine to me...

