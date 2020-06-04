Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1BB01EDCDC
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 08:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbgFDGAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 02:00:30 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35992 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726244AbgFDGA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 02:00:29 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0545WV5l143199;
        Thu, 4 Jun 2020 02:00:22 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31efd5b57r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Jun 2020 02:00:22 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0545xxLt022852;
        Thu, 4 Jun 2020 06:00:21 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma04dal.us.ibm.com with ESMTP id 31bf4ar9ct-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Jun 2020 06:00:21 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05460KJS10879774
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 4 Jun 2020 06:00:21 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C7B5EB2068;
        Thu,  4 Jun 2020 06:00:19 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5888DB206A;
        Thu,  4 Jun 2020 06:00:19 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.16.170.189])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu,  4 Jun 2020 06:00:19 +0000 (GMT)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 03 Jun 2020 23:00:18 -0700
From:   dwilder <dwilder@us.ibm.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        wilder@us.ibm.com, mkubecek@suse.com
In-Reply-To: <20200603220502.GD28263@breakpoint.cc>
References: <20200603212516.22414-1-dwilder@us.ibm.com>
 <20200603220502.GD28263@breakpoint.cc>
Message-ID: <72692f32471b5d2eeef9514bb2c9ba51@linux.vnet.ibm.com>
X-Sender: dwilder@us.ibm.com
User-Agent: Roundcube Webmail/1.0.1
X-TM-AS-GCONF: 00
Subject: RE: [(RFC) PATCH ] NULL pointer dereference on rmmod iptable_mangle.
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-04_01:2020-06-02,2020-06-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 cotscore=-2147483648 malwarescore=0
 adultscore=0 spamscore=0 clxscore=1011 impostorscore=0 priorityscore=1501
 bulkscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006040033
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-06-03 15:05, Florian Westphal wrote:
> David Wilder <dwilder@us.ibm.com> wrote:
>> This crash happened on a ppc64le system running ltp network tests when 
>> ltp script ran "rmmod iptable_mangle".
>> 
>> [213425.602369] BUG: Kernel NULL pointer dereference at 0x00000010
>> [213425.602388] Faulting instruction address: 0xc008000000550bdc
> [..]
> 
>> In the crash we find in iptable_mangle_hook() that 
>> state->net->ipv4.iptable_mangle=NULL causing a NULL pointer 
>> dereference. net->ipv4.iptable_mangle is set to NULL in 
>> iptable_mangle_net_exit() and called when ip_mangle modules is 
>> unloaded. A rmmod task was found in the crash dump.  A 2nd crash 
>> showed the same problem when running "rmmod iptable_filter" 
>> (net->ipv4.iptable_filter=NULL).
>> 
>> Once a hook is registered packets will picked up a pointer from: 
>> net->ipv4.iptable_$table. The patch adds a call to synchronize_net() 
>> in ipt_unregister_table() to insure no packets are in flight that have 
>> picked up the pointer before completing the un-register.
>> 
>> This change has has prevented the problem in our testing.  However, we 
>> have concerns with this change as it would mean that on netns cleanup, 
>> we would need one synchronize_net() call for every table in use. Also, 
>> on module unload, there would be one synchronize_net() for every 
>> existing netns.
> 
> Yes, I agree with the analysis.
> 
>> Signed-off-by: David Wilder <dwilder@us.ibm.com>
>> ---
>>  net/ipv4/netfilter/ip_tables.c | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>> 
>> diff --git a/net/ipv4/netfilter/ip_tables.c 
>> b/net/ipv4/netfilter/ip_tables.c
>> index c2670ea..97c4121 100644
>> --- a/net/ipv4/netfilter/ip_tables.c
>> +++ b/net/ipv4/netfilter/ip_tables.c
>> @@ -1800,8 +1800,10 @@ int ipt_register_table(struct net *net, const 
>> struct xt_table *table,
>>  void ipt_unregister_table(struct net *net, struct xt_table *table,
>>  			  const struct nf_hook_ops *ops)
>>  {
>> -	if (ops)
>> +	if (ops) {
>>  		nf_unregister_net_hooks(net, ops, hweight32(table->valid_hooks));
>> +		synchronize_net();
>> +	}
> 
> I'd wager ebtables, arptables and ip6tables have the same bug.
> 
> The extra synchronize_net() isn't ideal.  We could probably do it this
> way and then improve in a second patch.
> 
> One way to fix this without a new synchronize_net() is to switch all
> iptable_foo.c to use ".pre_exit" hook as well.
> 
> pre_exit would unregister the underlying hook and .exit would to the
> table freeing.
> 
> Since the netns core already does an unconditional synchronize_rcu 
> after
> the pre_exit hooks this would avoid the problem as well.

Something like this?  (un-tested)

diff --git a/net/ipv4/netfilter/iptable_mangle.c 
b/net/ipv4/netfilter/iptable_mangle.c
index bb9266ea3785..0d448e4d5213 100644
--- a/net/ipv4/netfilter/iptable_mangle.c
+++ b/net/ipv4/netfilter/iptable_mangle.c
@@ -100,15 +100,26 @@ static int __net_init 
iptable_mangle_table_init(struct net *net)
         return ret;
  }

+static void __net_exit iptable_mangle_net_pre_exit(struct net *net)
+{
+       struct xt_table *table = net->ipv4.iptable_mangle;
+
+       if (mangle_ops)
+               nf_unregister_net_hooks(net, mangle_ops,
+                       hweight32(table->valid_hooks));
+}
+
+
  static void __net_exit iptable_mangle_net_exit(struct net *net)
  {
         if (!net->ipv4.iptable_mangle)
                 return;
-       ipt_unregister_table(net, net->ipv4.iptable_mangle, mangle_ops);
+       ipt_unregister_table(net, net->ipv4.iptable_mangle, NULL);
         net->ipv4.iptable_mangle = NULL;
  }

  static struct pernet_operations iptable_mangle_net_ops = {
+       .pre_exit = iptable_mangle_net_pre_exit,
         .exit = iptable_mangle_net_exit,
  };

