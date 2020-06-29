Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCA8420D465
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 21:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730855AbgF2TIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:08:01 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42158 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730534AbgF2THn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:07:43 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05THrpFC099171;
        Mon, 29 Jun 2020 17:57:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Th9j2rJrwRXpmODdSGs/DYnq7ge1mBicBNf2nmL5+hQ=;
 b=oiiMJsjVeyrusyP+g5xhhQBGTMSz1eLGLgwdMSaVlX7aORXZZE3ETqp+x2NGqDfbetB5
 AYyo3bKLPTzHO9qDOeInSRPQ9ED9Oh6nHYUsFNkJnnn/HD3wdVnVdnZpGsvkUiJ+byvE
 2gYblhBq65MfTT8P7YFB3tfUoZTYJy+cm2237x/W3wcmHezuOUpMwRjDoqA7uG1dpnMN
 9CMCFDBsJaiDKD0K+DVF966Kw6KYO5IlqBHTMQ+OX8jqvtq3GQB3VsU47AKSwAH8YLYa
 ssTTMCvqPQbKoGwLCImBrAwkFjwI3laNctnPsGNGxrhK0YXfbbuV70Nf1MXCJk0ygkfc Qw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 31wwhrfypa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 29 Jun 2020 17:57:37 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05THbhDE023867;
        Mon, 29 Jun 2020 17:55:36 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 31xg1vd4fx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Jun 2020 17:55:36 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05THtZir019722;
        Mon, 29 Jun 2020 17:55:36 GMT
Received: from [192.168.1.7] (/73.15.177.101)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 29 Jun 2020 17:55:35 +0000
Subject: Re: [PATCH v1] rds: If one path needs re-connection, check all and
 re-connect
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        ka-cheong.poon@oracle.com, david.edmondson@oracle.com
References: <20200626183438.20188-1-rao.shoaib@oracle.com>
 <20200626.163100.603726050168307590.davem@davemloft.net>
From:   Rao Shoaib <rao.shoaib@oracle.com>
Message-ID: <ba7da46b-a84d-142f-90e2-6b0be6899fbf@oracle.com>
Date:   Mon, 29 Jun 2020 10:55:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200626.163100.603726050168307590.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9667 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006290112
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9667 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 phishscore=0 priorityscore=1501 clxscore=1015 cotscore=-2147483648
 mlxscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0
 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006290113
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 6/26/20 4:31 PM, David Miller wrote:
> From: rao.shoaib@oracle.com
> Date: Fri, 26 Jun 2020 11:34:38 -0700
>
>> +/* Check connectivity of all paths
>> + */
>> +void rds_check_all_paths(struct rds_connection *conn)
>> +{
>> +	int i = 0;
>> +
>> +	do {
>> +		rds_conn_path_connect_if_down(&conn->c_path[i]);
>> +	} while (++i < conn->c_npaths);
>> +}
> Please code this loop in a more canonial way:
>
> 	int i;
>
> 	for (i = 0; i < conn->c_npaths, i++)
> 		rds_conn_path_connect_if_down(&conn->c_path[i]);
>
> Thank you.

This was coded in this unusual way because the code is agnostic to the 
underlying transport. Unfortunately, IB transport does not 
initialize/use this field where as TCP does and counts starting from one.

If this is not acceptable, I would have to introduce a check for the 
transport or deal with zero count separately.

Let me know.

Regards,

Shoaib



