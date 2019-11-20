Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A38FD1042F7
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 19:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728362AbfKTSIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 13:08:05 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:52726 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726999AbfKTSIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 13:08:05 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAKI453R155903;
        Wed, 20 Nov 2019 18:07:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=7Iuk+cmislWerMgl6GxZr/jsZWnl3r60L9MDrOd/kek=;
 b=nbE8NfUyEi19XhG3AmSub6bubypkT66Nq2ANkiIGUjKGFeEzof7rLjoxbBQBP4ipdUwb
 P+hIj/eiWUZGrc5mzo/sdkgpqFaJGyzahqVLkfLIZcddTCzjg/THeUqpkZgvqFDWnkEp
 y4BVL6WC/iPGGa1/HV6gSMSdHIK2tpHAyc2nh1bXgKQYIOmpRCASGU7LS3eX/gQSgFny
 EHjjargxtwQzRn3E3u6s4ZFt2PUZQygJJKYl7ze2FZYGoNZAGec+6OZImzIbDHuQLkn8
 /uzsYkkAcEV/PDzxFDASVMYZKVm1xFByXbKHh+iYhhDysQsChyOiy16Asjm2x+Oovn3s mA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2wa9rqq70h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 18:07:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAKI4W78033063;
        Wed, 20 Nov 2019 18:07:48 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2wda04hga8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 18:07:48 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAKI7kU0001726;
        Wed, 20 Nov 2019 18:07:46 GMT
Received: from kadam (/41.210.141.247)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 Nov 2019 10:07:46 -0800
Date:   Wed, 20 Nov 2019 21:07:35 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Petr Machata <petrm@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Parav Pandit <parav@mellanox.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] net: rtnetlink: prevent underflows in do_setvfinfo()
Message-ID: <20191120180735.GD5604@kadam>
References: <20191120123438.vxn2ngnxzpcaqot4@kili.mountain>
 <24d0482c-f23f-83b1-e79e-fb84694d0a54@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24d0482c-f23f-83b1-e79e-fb84694d0a54@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9446 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=959
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911200152
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9446 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911200152
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 20, 2019 at 09:41:01AM -0700, David Ahern wrote:
> On 11/20/19 5:34 AM, Dan Carpenter wrote:
> > I reported this bug to the linux-rdma mailing list in April and this
> > patch wasn't considered very elegant.  I can see how that's true.  The
> > developer offered to write a fix which would update all the drivers to
> > use u32 throughout.  I reminded him in September that this bug still
> > needs to be fixed.
> 
> Since the uapi (ifla_vf_mac, ifla_vf_vlan, ...) all have u32, I agree
> with that comment -- it seems like the ndo functions should be changed
> from 'int vf' to 'u32 vf'.

It's a lot of changes and there is no way to be sure the static checker
isn't missing any bugs.

regards,
dan carpenter
