Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 411AF195B26
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 17:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbgC0QeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 12:34:03 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58490 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727352AbgC0QeC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 12:34:02 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02RGMSEh134501;
        Fri, 27 Mar 2020 16:33:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=jtn7o2RhFvINwYlF9zAidEwSZ9rhb3VsE2CDhAlOads=;
 b=ATmBjj0I7w4miIptaUNnsW0Rn/WJOQoompsthfwAI4TxezVefXJe4TUOgLTCiZPK2mdg
 rYBifw88+pJkeIwBpdSTbNq2rEIAewVB5m9BVFvZITH2GWFRx5fiF0Scj7DnALI6UwTs
 7Qd/3G3GBhlqv0nU9TmsCOiRE6/5PMhnzidP4WV/dBPL96aMBSAA0lGweI+xgmexPfj3
 7XFTFmJhOl+UdnQ9qTOC2I+zZ/YDuMV3uMGE1lhdP5fuRU1zaOdXMVcX36YbeQ5CqL8+
 MKrpefzdHpo3vgGrqmlX7ov8/k/ngEXl7HdKKTEg9mMhSOz35JL+SUWeyC/S7JHhTQfm Hg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 3019veb8cb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 16:33:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02RGW4jJ121146;
        Fri, 27 Mar 2020 16:33:43 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 3003gp8xvx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 16:33:42 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02RGXcUd019210;
        Fri, 27 Mar 2020 16:33:38 GMT
Received: from anon-dhcp-153.1015granger.net (/68.61.232.219)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 27 Mar 2020 09:33:38 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH V2] SUNRPC: Fix a potential buffer overflow in
 'svc_print_xprts()'
From:   Chuck Lever <chuck.lever@oracle.com>
In-Reply-To: <20200327161539.21554-1-christophe.jaillet@wanadoo.fr>
Date:   Fri, 27 Mar 2020 12:33:36 -0400
Cc:     Bruce Fields <bfields@fieldses.org>,
        trond.myklebust@hammerspace.com,
        Anna Schumaker <anna.schumaker@netapp.com>,
        davem@davemloft.net, kuba@kernel.org, Neil Brown <neilb@suse.de>,
        Tom Tucker <tom@opengridcomputing.com>, gnb@sgi.com,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <EC65FE50-6CEC-4D97-9011-2A88F63C26D7@oracle.com>
References: <20200327161539.21554-1-christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
X-Mailer: Apple Mail (2.3445.104.11)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9573 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 adultscore=0 spamscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003270145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9573 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0 phishscore=0
 clxscore=1011 adultscore=0 spamscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003270144
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 27, 2020, at 12:15 PM, Christophe JAILLET =
<christophe.jaillet@wanadoo.fr> wrote:
>=20
> 'maxlen' is the total size of the destination buffer. There is only =
one
> caller and this value is 256.
>=20
> When we compute the size already used and what we would like to add in
> the buffer, the trailling NULL character is not taken into account.
> However, this trailling character will be added by the 'strcat' once =
we
> have checked that we have enough place.
>=20
> So, there is a off-by-one issue and 1 byte of the stack could be
> erroneously overwridden.
>=20
> Take into account the trailling NULL, when checking if there is enough
> place in the destination buffer.
>=20
>=20
> While at it, also replace a 'sprintf' by a safer 'snprintf', check for
> output truncation and avoid a superfluous 'strlen'.
>=20
> Fixes: dc9a16e49dbba ("svc: Add /proc/sys/sunrpc/transport files")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> V2: add a doxygen comment to clarify the goal of the function
>    merge previous 2 patches into a single one
>    keep strcat for clarity, this function being just a slow path =
anyway
>=20
> Doc being most of the time a matter of taste, please adjust the =
description
> as needed.

I've applied this to my local nfsd-5.7 with a very small adjustment
to the doc-comment. Testing it now. Thanks, all.


> ---
> net/sunrpc/svc_xprt.c | 19 ++++++++++++++-----
> 1 file changed, 14 insertions(+), 5 deletions(-)
>=20
> diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
> index de3c077733a7..e0f61a8c1965 100644
> --- a/net/sunrpc/svc_xprt.c
> +++ b/net/sunrpc/svc_xprt.c
> @@ -104,8 +104,17 @@ void svc_unreg_xprt_class(struct svc_xprt_class =
*xcl)
> }
> EXPORT_SYMBOL_GPL(svc_unreg_xprt_class);
>=20
> -/*
> - * Format the transport list for printing
> +/**
> + * svc_print_xprts - Format the transport list for printing
> + * @buf: target buffer for formatted address
> + * @maxlen: length of target buffer
> + *
> + * Fills in @buf with a string containing a list of transport names, =
each name
> + * terminated with '\n'. If the buffer is too small, some entries may =
be
> + * missing, but it is guaranteed that the line in the output buffer =
are
> + * complete.
> + *
> + * Returns positive length of the filled-in string.
>  */
> int svc_print_xprts(char *buf, int maxlen)
> {
> @@ -118,9 +127,9 @@ int svc_print_xprts(char *buf, int maxlen)
> 	list_for_each_entry(xcl, &svc_xprt_class_list, xcl_list) {
> 		int slen;
>=20
> -		sprintf(tmpstr, "%s %d\n", xcl->xcl_name, =
xcl->xcl_max_payload);
> -		slen =3D strlen(tmpstr);
> -		if (len + slen > maxlen)
> +		slen =3D snprintf(tmpstr, sizeof(tmpstr), "%s %d\n",
> +				xcl->xcl_name, xcl->xcl_max_payload);
> +		if (slen >=3D sizeof(tmpstr) || len + slen >=3D maxlen)
> 			break;
> 		len +=3D slen;
> 		strcat(buf, tmpstr);
> --=20
> 2.20.1
>=20

--
Chuck Lever



