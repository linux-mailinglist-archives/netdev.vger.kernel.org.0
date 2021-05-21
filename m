Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1282938CCD9
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 20:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238221AbhEUSDR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 21 May 2021 14:03:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52044 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232931AbhEUSDQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 14:03:16 -0400
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1lk9T1-00025v-Vq; Fri, 21 May 2021 18:01:48 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id 554A85FDD5; Fri, 21 May 2021 11:01:46 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 46D90A040C;
        Fri, 21 May 2021 11:01:46 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
cc:     Jarod Wilson <jarod@redhat.com>, linux-kernel@vger.kernel.org,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/4] bonding: add pure source-mac-based tx hashing option
In-reply-to: <cfdef650-265c-19fb-de91-0f1ad0fed3e5@nvidia.com>
References: <20210518210849.1673577-1-jarod@redhat.com> <20210521132756.1811620-1-jarod@redhat.com> <20210521132756.1811620-2-jarod@redhat.com> <cfdef650-265c-19fb-de91-0f1ad0fed3e5@nvidia.com>
Comments: In-reply-to Nikolay Aleksandrov <nikolay@nvidia.com>
   message dated "Fri, 21 May 2021 16:39:20 +0300."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <21483.1621620106.1@famine>
Content-Transfer-Encoding: 8BIT
Date:   Fri, 21 May 2021 11:01:46 -0700
Message-ID: <21484.1621620106@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nikolay Aleksandrov <nikolay@nvidia.com> wrote:

>On 21/05/2021 16:27, Jarod Wilson wrote:
>> As it turns out, a pure source-mac only tx hash has a place for some VM
>> setups. The previously added vlan+srcmac hash doesn't work as well for a
>> VM with a single MAC and multiple vlans -- these types of setups path
>> traffic more efficiently if the load is split by source mac alone. Enable
>> this by way of an extra module parameter, rather than adding yet another
>> hashing method in the tx fast path.
>> 
>> Cc: Jay Vosburgh <j.vosburgh@gmail.com>
>> Cc: Veaceslav Falico <vfalico@gmail.com>
>> Cc: Andy Gospodarek <andy@greyhouse.net>
>> Cc: "David S. Miller" <davem@davemloft.net>
>> Cc: Jakub Kicinski <kuba@kernel.org>
>> Cc: Thomas Davis <tadavis@lbl.gov>
>> Cc: Nikolay Aleksandrov <nikolay@nvidia.com>
>> Cc: netdev@vger.kernel.org
>> Signed-off-by: Jarod Wilson <jarod@redhat.com>
>> ---
>>  Documentation/networking/bonding.rst | 13 +++++++++++++
>>  drivers/net/bonding/bond_main.c      | 18 ++++++++++++------
>>  2 files changed, 25 insertions(+), 6 deletions(-)
>> 
>
>Hi,
>You seem to be missing netlink support for the new option. Code-wise the rest seems fine,
>my personal preference is still to make a configurable hash option and perhaps default to
>srcmac+vlan, i.e. it can be aliased with this hash option. I don't mind either way, but
>please add netlink support if it will be a new option as it's the preferred way for
>configuring.

	FWIW, I'm in agreement with Nik here; netlink support is
mandatory for any new options.

	-J

>Thanks,
> Nik
>
>> diff --git a/Documentation/networking/bonding.rst b/Documentation/networking/bonding.rst
>> index 62f2aab8eaec..767dbb49018b 100644
>> --- a/Documentation/networking/bonding.rst
>> +++ b/Documentation/networking/bonding.rst
>> @@ -707,6 +707,13 @@ mode
>>  		swapped with the new curr_active_slave that was
>>  		chosen.
>>  
>> +novlan_srcmac
>> +
>> +	When using the vlan+srcmac xmit_hash_policy, there may be cases where
>> +	omitting the vlan from the hash is beneficial. This can be done with
>> +	an extra module parameter here. The default value is 0 to include
>> +	vlan ID in the transmit hash.
>> +
>>  num_grat_arp,
>>  num_unsol_na
>>  
>> @@ -964,6 +971,12 @@ xmit_hash_policy
>>  
>>  		hash = (vlan ID) XOR (source MAC vendor) XOR (source MAC dev)
>>  
>> +		Optionally, if the module parameter novlan_srcmac=1 is set,
>> +		the vlan ID is omitted from the hash and only the source MAC
>> +		address is used, reducing the hash to
>> +
>> +		hash = (source MAC vendor) XOR (source MAC dev)
>> +
>>  	The default value is layer2.  This option was added in bonding
>>  	version 2.6.3.  In earlier versions of bonding, this parameter
>>  	does not exist, and the layer2 policy is the only policy.  The
>> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>> index 20bbda1b36e1..32785e9d0295 100644
>> --- a/drivers/net/bonding/bond_main.c
>> +++ b/drivers/net/bonding/bond_main.c
>> @@ -107,6 +107,7 @@ static char *lacp_rate;
>>  static int min_links;
>>  static char *ad_select;
>>  static char *xmit_hash_policy;
>> +static int novlan_srcmac;
>>  static int arp_interval;
>>  static char *arp_ip_target[BOND_MAX_ARP_TARGETS];
>>  static char *arp_validate;
>> @@ -168,6 +169,9 @@ MODULE_PARM_DESC(xmit_hash_policy, "balance-alb, balance-tlb, balance-xor, 802.3
>>  				   "0 for layer 2 (default), 1 for layer 3+4, "
>>  				   "2 for layer 2+3, 3 for encap layer 2+3, "
>>  				   "4 for encap layer 3+4, 5 for vlan+srcmac");
>> +module_param(novlan_srcmac, int, 0);
>> +MODULE_PARM_DESC(novlan_srcmac, "include vlan ID in vlan+srcmac xmit_hash_policy or not; "
>> +			      "0 to include it (default), 1 to exclude it");
>>  module_param(arp_interval, int, 0);
>>  MODULE_PARM_DESC(arp_interval, "arp interval in milliseconds");
>>  module_param_array(arp_ip_target, charp, NULL, 0);
>> @@ -3523,9 +3527,9 @@ static bool bond_flow_ip(struct sk_buff *skb, struct flow_keys *fk,
>>  
>>  static u32 bond_vlan_srcmac_hash(struct sk_buff *skb)
>>  {
>> -	struct ethhdr *mac_hdr = (struct ethhdr *)skb_mac_header(skb);
>> +	struct ethhdr *mac_hdr = eth_hdr(skb);
>>  	u32 srcmac_vendor = 0, srcmac_dev = 0;
>> -	u16 vlan;
>> +	u32 hash;
>>  	int i;
>>  
>>  	for (i = 0; i < 3; i++)
>> @@ -3534,12 +3538,14 @@ static u32 bond_vlan_srcmac_hash(struct sk_buff *skb)
>>  	for (i = 3; i < ETH_ALEN; i++)
>>  		srcmac_dev = (srcmac_dev << 8) | mac_hdr->h_source[i];
>>  
>> -	if (!skb_vlan_tag_present(skb))
>> -		return srcmac_vendor ^ srcmac_dev;
>> +	hash = srcmac_vendor ^ srcmac_dev;
>> +
>> +	if (novlan_srcmac || !skb_vlan_tag_present(skb))
>> +		return hash;
>>  
>> -	vlan = skb_vlan_tag_get(skb);
>> +	hash ^= skb_vlan_tag_get(skb);
>>  
>> -	return vlan ^ srcmac_vendor ^ srcmac_dev;
>> +	return hash;
>>  }
>>  
>>  /* Extract the appropriate headers based on bond's xmit policy */

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
