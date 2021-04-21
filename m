Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 529C43672DC
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 20:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245304AbhDUSum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 14:50:42 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58282 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235269AbhDUSuk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 14:50:40 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13LIYgjb019551;
        Wed, 21 Apr 2021 14:49:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=+A2nlYnV9AqILYBgSEDrI1rjU2s1EhSOVPAGwgcgaR0=;
 b=ef1I65UmotSXt+H2RG+ZFLEFu+9Sdm0yTnE5/xmXBo/OAi04PF3H5P3gJ5Hgd7xZVu+a
 eNK24liuQ22otvV2sKFhzvTPEwL7gm8CoX7xBThvRoVlWjvV+z07g0iJaqBOYiZvEyrn
 s5yLc46ufrt92oU5RfEPlrEZMD1K1GWxUz8oFfBJdLV555nqpKf20k/9DLm4xnrQpvMX
 tmG28RdIhzVHESyjMg+97OC5e6Qs0qpl34Ceo3JFF/TlbsPIGzWZqr/Cf/3THFMUBnT8
 RS4AKHYZxiRJDYoW63zRS+hVjpNH4npbX3wsQ/0tI60hUR4MTJGSzccoJ5kDPe5mCzBu 1g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 382s4vgy20-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Apr 2021 14:49:53 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13LIZNNp025193;
        Wed, 21 Apr 2021 14:49:52 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 382s4vgy1f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Apr 2021 14:49:52 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13LIhFLe031929;
        Wed, 21 Apr 2021 18:49:50 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 37yqa89bnt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Apr 2021 18:49:50 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13LInldl32702848
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Apr 2021 18:49:47 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9FA015204F;
        Wed, 21 Apr 2021 18:49:47 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.22.74])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id DB62D52050;
        Wed, 21 Apr 2021 18:49:46 +0000 (GMT)
Subject: Re: [PATCH net-next] net: bridge: fix error in br_multicast_add_port
 when CONFIG_NET_SWITCHDEV=n
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20210421184420.1584100-1-olteanv@gmail.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <0dad9fe4-0ace-16b7-aca1-f2e824e2e7b5@de.ibm.com>
Date:   Wed, 21 Apr 2021 20:49:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210421184420.1584100-1-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: fhN1GJFq-h-Yeaesmc3Eyiz7I1DgpMYQ
X-Proofpoint-GUID: oZzM4kmeN1VSoC-r9l_mfqInopZ1KRAp
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-21_05:2021-04-21,2021-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 suspectscore=0 bulkscore=0 priorityscore=1501 mlxscore=0 malwarescore=0
 phishscore=0 lowpriorityscore=0 impostorscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104210128
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 21.04.21 20:44, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> When CONFIG_NET_SWITCHDEV is disabled, the shim for switchdev_port_attr_set
> inside br_mc_disabled_update returns -EOPNOTSUPP. This is not caught,
> and propagated to the caller of br_multicast_add_port, preventing ports
> from joining the bridge.
> 
> Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Fixes: ae1ea84b33da ("net: bridge: propagate error code and extack from br_mc_disabled_update")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

yes this works now:

Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>


> ---
>   net/bridge/br_multicast.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
> index 4daa95c913d0..2883601d5c8b 100644
> --- a/net/bridge/br_multicast.c
> +++ b/net/bridge/br_multicast.c
> @@ -1625,7 +1625,7 @@ int br_multicast_add_port(struct net_bridge_port *port)
>   				    br_opt_get(port->br,
>   					       BROPT_MULTICAST_ENABLED),
>   				    NULL);
> -	if (err)
> +	if (err && err != -EOPNOTSUPP)
>   		return err;
>   
>   	port->mcast_stats = netdev_alloc_pcpu_stats(struct bridge_mcast_stats);
> 
