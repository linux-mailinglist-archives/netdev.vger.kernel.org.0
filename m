Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 631626903F7
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 10:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjBIJjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 04:39:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjBIJja (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 04:39:30 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C61A5EFBD;
        Thu,  9 Feb 2023 01:39:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ci5aQWPa0OQfF6U+xaScDtAEGVIe6lQKSXPCK6ISbn6U7WkiPRnGQsoUxqk6zGW/ry/RN/4kcfKRxVnxt3guxI02Zb1z2221rZ2EfkJRUKaWITYalcYEhYZK1cg/14GFzOLvdEC+tl7pc/X2sjXSW6XDd6qLUmVMCPmtin5eyXulTp5j8hCx73PEK/s7uH1EXeGIj/bQ5QtkJ7Vl3qzsEs2Q2gKq5zjhgY+LtDrVECDXnwMT+vVxngkaMXE4qn0Mw0uEzv5+3icmOp5v4mSdIOw8s4DMPIL9zTqg9LIAWqCmpt5LhxgQ7gRBgd8iR+ud+3FaNdEro6jkUuMZ+kg55Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NKzkfH2J9RMkHz0SHtBSh1X6CAAsGpKP5rNxsiTLQl0=;
 b=YbJej0siHQyyMqzw06ZJFEYipTeeLC2UAwxASzer/wZuS2X5HWst4hrXXSaRIU1Bi+hh0JMYRfH4fZ9LJG1klUuiG/Vjy/pTG6fzmz2IKK97l0DF/q5UYkHyisZ7d7chdkv4xcS4gGeS3ZWrLp5z6erbYVifGLPpvD1Q4V+okIog1MEedoTN8G5oYipDJbOcayTCmJHwlF3h2c3lv/C/zFP1iCvo3BtLknM7n6LaJ7yPfwcTwK4acI17101inqGOPn2jPxLgQmcQy3XdqClsdsTrcUAJ9b9k0jQK+4lGZzVjW0ZZstLffQHnmrD1XhJZgQKXJJYq2X0ZnFSf/npMkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NKzkfH2J9RMkHz0SHtBSh1X6CAAsGpKP5rNxsiTLQl0=;
 b=m+NcGMap5rquBamf7KMpnO+MgrhhnaAUDaPINuj0QiexlwXdKw0KB7pihWom2dl1CRdvhCZQZkWAX6u9SwHF7wcfyxwmbLTd5yYMIKzwAtcrWs+2cZ23UOZ8LITCstDj5RSpNqF0xkPE6PIYVRE5jKZfYqfSIa94wncTCisORdc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW4PR13MB5578.namprd13.prod.outlook.com (2603:10b6:303:182::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Thu, 9 Feb
 2023 09:38:22 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%7]) with mapi id 15.20.6086.017; Thu, 9 Feb 2023
 09:38:21 +0000
Date:   Thu, 9 Feb 2023 10:38:15 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Alexandra Winter <wintera@linux.ibm.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Thorsten Winkler <twinkler@linux.ibm.com>,
        Jules Irenge <jbi.octave@gmail.com>
Subject: Re: [PATCH net-next 4/4] s390/qeth: Convert sprintf/snprintf to
 scnprintf
Message-ID: <Y+S/B3Q/En1UzrWW@corigine.com>
References: <20230206172754.980062-1-wintera@linux.ibm.com>
 <20230206172754.980062-5-wintera@linux.ibm.com>
 <Y+JxcPOJiRl0qMo1@corigine.com>
 <045d16d2-fca2-4dbe-e999-05d5365da1ad@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <045d16d2-fca2-4dbe-e999-05d5365da1ad@linux.ibm.com>
X-ClientProxiedBy: AM0PR08CA0034.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::47) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW4PR13MB5578:EE_
X-MS-Office365-Filtering-Correlation-Id: ebd36be3-8aa6-4df8-3ff6-08db0a816224
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qmhNd9xdP+evmf3VCO0hI0a7G7ygtHriYtmLV9k7aK87yD3aqbyxAaQf9uDtawy2HNivlvjpvgPIT0I1eCK8yVx6u++7EOv3HRv1e0ZfQN1mkQ4COfCNHGci663AV0QPGZ3U3cFhJ97RwKld1QAKbBAsXlx8fSL7OluNa0UoWlQ7VJt09fvZ4Ds2ihL8OLdXy6mK14B519L4XzoZdA1NsdE5O73KRR1/0AbNzghx1I+1k887LxsDR2kimSdzL0DWwILcFzMIjN6KmiOMphHkPK6Ya13dtnAcDsdTUKfoEeYYQkdy6Pmwz/u5PLMftPzWmpLTl9aa2+8dEewvfskefOZtc6SEm34pc/MOxWwJGSX20bSDyH8rUHl9C8hYxojckxLF4jH4liVwPx77ZN+BJIqzymPzXuFyqDvAGjKo1/gKaTXKIkVMVDQe0rCSiJMV/YXQSjEu+a7yVFrQaUavTgIG7iXC6EEs+oeMNM+ocw31GYjPMz/oifYOmQCXOCmiSIcOjGT33sP5NupIB06LeNJ/Skl8N7r7q0pUhVHr33rWKbVkBuQkQ3c4G6Q/ylFmebVm7dnb7LLYfu3kXPNFtIm7dFa9xQXyl4qydSSCTDAP46G+awFfoxlI6I/YetEyXOy7elJ/zJGS7zUCXgEh2V1rsJeu/orC+BKLNktNrEv4Y2c79OMajb0gaq1hharWfbTuwKQo3HBE/hfgwYvaaOqoLw02Z1hCuz53XEF9x10=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(376002)(396003)(136003)(39840400004)(346002)(451199018)(83380400001)(2616005)(478600001)(54906003)(2906002)(316002)(6486002)(38100700002)(36756003)(966005)(66946007)(4326008)(66556008)(44832011)(41300700001)(6506007)(6916009)(8676002)(5660300002)(8936002)(86362001)(6512007)(186003)(53546011)(6666004)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UjnHkfmYlvhZg2qfsYDmQgOKhqOuSEqX9wLKKeBqUKHPiWCditqUwsJpVtUT?=
 =?us-ascii?Q?L+vaRs1wWJL1bo/8y+v7TMhC6/lSP7Di7G7WSKu2LknQ26OSnAVVlbhnaSZk?=
 =?us-ascii?Q?G8ZFFM35dqn/xwEKMWTa6j9Bu5jltIOETvcqY1HGSUgBfOodgjlDNDiJjwIZ?=
 =?us-ascii?Q?EoI6A8QldKiYaBZJ7ProidEs8Hgq+wCgn77tALcUxlD4Nzw0kTUWjXACSTjN?=
 =?us-ascii?Q?kJmsTdvUekiTyTmGRwiSNew8NWYIxPKAQb+5ZxHPl4uCokP2G4x1PcRQKmEY?=
 =?us-ascii?Q?xEL7n6LrukkOC+p9CWjykhks96bIIYHMsq1ESJKXTwYYXEQPpIoz7bxW2UGZ?=
 =?us-ascii?Q?4ujnZm4LwAuCRHqNPBmGhdk4cdvTRXIVQFh1PjJWlkqu/oIdHXv+BnXyUSc5?=
 =?us-ascii?Q?7otGDrGvbwcr5JxSGkb6KbUwbAo3yvXx+OXm+Hs0Jpf+hHo61si881UndhHe?=
 =?us-ascii?Q?ydoTSGWk0iZEiBUpVW62kJXOxQ4vYZPzgK0G65oK1YdrBgrZ406O3NyVm4sY?=
 =?us-ascii?Q?WdRsIiDCqBXQem6T3TokcT+3ifXewl7YPsFj3pbjWvTrlZ0TlU2SbWJaNxrm?=
 =?us-ascii?Q?UGYENcTxpcLKfBpuq6tK1DR9PNMXdj/ix/TpI6/zVCw+C05Hb5ClB4T3fd39?=
 =?us-ascii?Q?VWwM0ILeBy5JRKk2V+ylgVG2TFc/RamY2+XPc37Y3hPmOQV5o+1vg/w5GS8I?=
 =?us-ascii?Q?e+zyhVYEB5OLGzE03nAuGi00bdowwDyynDlZiayrA/Pu1b3IcgtfDs1lL3Pj?=
 =?us-ascii?Q?zEKcY0+q4JRFl/9HtWNH41xGJq5cmMPMFDAnQ6ncb973gPwotZTbjrb/zdRH?=
 =?us-ascii?Q?sBR1ER2W6XjUA5T3V16MPSFLXXAHhYTyt7XJZS2C4DYHrenrsbNev33ow5+F?=
 =?us-ascii?Q?yWCJls+dh8hJhzlC/uIpLCn6pOfxglsARwYqcCpDnZ1/rO7gxexJk3d/7c1P?=
 =?us-ascii?Q?q4j7xV5MUWgB7IBTtZVDJHPhduxq8nC1f48Y1hpxsWbb9buMtmkHbLKUig0o?=
 =?us-ascii?Q?hb27yGDMROQvKc3c1UbsWJkCEMDjfXw3MtJSr19sDzTfw0FSJcaLeMBNT3V0?=
 =?us-ascii?Q?dcj3raKJ9NRzD+8v3NVu2tVlBYRsQWPU3/070RXKN1R0ESSovbjoqoeQOnl5?=
 =?us-ascii?Q?T0N6HsxhmAeqyDb9cbSE4dwEJXFz9aisDmApvnDIqaNE648pKPCF/X0IAria?=
 =?us-ascii?Q?9uZ+DiRWOvjhdli7+HcdRqGkBG0xzaK5X4uq97tpiBQa2u8XacGmhosbjPWi?=
 =?us-ascii?Q?kJx3998iRGBO+ImGCNjCPdCLyig6yreFpssRQzXhpUrtNtmjYOyGddXUGYwy?=
 =?us-ascii?Q?chZsH1/EOrT0cTfUoOpMDM7cuqsPFg8etkem3mQwgFQi2HrKk7hZxLE8nRkE?=
 =?us-ascii?Q?SqpaRCLiPu4DiptxEl2POqRW30bd1mGV+MH0HMj0tjtoy/rtf78slkxqi3xv?=
 =?us-ascii?Q?JhmorSZ2yflGZUpOxmxRlCvy0v/f56VnXCrP+eBBNqmoncGsrBej23wdr13o?=
 =?us-ascii?Q?r4o6J7x1z6NMgLlTK3ubyGSmEl4G3aKz56ptVtX8tIs9HzPxBRA0jkiTb+S3?=
 =?us-ascii?Q?mlCzpDjyA/2rqj/fkxHGyKozRn6E+hU8jLe6aztp+WigzqAXB9z4+mT/ocLd?=
 =?us-ascii?Q?zaZwppzrp/2XhlhCC0Yk98gAbZ3Io4+TbufkwY3Wj0Kg42AnZ26uzG8KDoE9?=
 =?us-ascii?Q?V+98BQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebd36be3-8aa6-4df8-3ff6-08db0a816224
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 09:38:21.8689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j4vGL+dD7QWvvfxi9KlX6+NeCiL6GTAHJg8IhcI41Sw4T52zrumoLQY9TGCleBdRAZBWEJASROlLquFZrH62SHl/rMWQI11jP3hmS61btLA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR13MB5578
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 08, 2023 at 07:19:29PM +0100, Alexandra Winter wrote:
> 
> 
> On 07.02.23 16:42, Simon Horman wrote:
> > On Mon, Feb 06, 2023 at 06:27:54PM +0100, Alexandra Winter wrote:
> >> From: Thorsten Winkler <twinkler@linux.ibm.com>
> >>
> >> This LWN article explains the rationale for this change
> >> https: //lwn.net/Articles/69419/
> > 
> > https://lwn.net/Articles/69419/
> > 
> >> Ie. snprintf() returns what *would* be the resulting length,
> >> while scnprintf() returns the actual length.
> > 
> > Ok, but in most cases in this patch the return value is not checked.
> > Is there any value in this change in those cases?
> > 
> 
> Jules Irenge reported a coccinnelle warning to use scnprintf in 
> show() functions [1]. (Thorsten Winkler changed these instances to
> sysfs_emit in patch 3 of this series.)
> We read the article as a call to implement the plan to upgrade the kernel
> to the newer *scnprintf functions. Is that not intended?
>
> I totally agree, that in these cases no real problem was fixed, it is
> more of a style improvement.

My feeling is that it isn't an improvement and therefore probably
best not done. But that is just my opinion.

> [1] https://lore.kernel.org/netdev/YzHyniCyf+G%2F2xI8@fedora/T/
> 
> >> Reported-by: Jules Irenge <jbi.octave@gmail.com>
> >> Reviewed-by: Alexandra Winkler <wintera@linux.ibm.com>
> > 
> > s/Winkler/Winter/ ?
> 
> Of course. Wow, you have good eyes!

Only on my good days.

> >> Signed-off-by: Thorsten Winkler <twinkler@linux.ibm.com>
> >> Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
> > 
> > ...
> > 
> >> diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
> >> index 1cf4e354693f..af4e60d2917e 100644
> >> --- a/drivers/s390/net/qeth_l3_main.c
> >> +++ b/drivers/s390/net/qeth_l3_main.c
> >> @@ -47,9 +47,9 @@ int qeth_l3_ipaddr_to_string(enum qeth_prot_versions proto, const u8 *addr,
> >>  			     char *buf)
> >>  {
> >>  	if (proto == QETH_PROT_IPV4)
> >> -		return sprintf(buf, "%pI4", addr);
> >> +		return scnprintf(buf, INET_ADDRSTRLEN, "%pI4", addr);
> >>  	else
> >> -		return sprintf(buf, "%pI6", addr);
> >> +		return scnprintf(buf, INET6_ADDRSTRLEN, "%pI6", addr);
> >>  }
> > 
> > 
> > This seems to be the once case where the return value is not ignored.
> > 
> > Of the 4 callers of qeth_l3_ipaddr_to_string, two don't ignore the return
> > value. And I agree in those cases this change seems correct.
> > 
> > However, amongst other usages of the return value,
> > those callers also check for a return < 0 from this function.
> > Can that occur, in the sprintf or scnprintf case?
> 
> I was under the impression this was a safeguard against a bad address format,
> but I tried it out and it never resulted in a negative return.
> Thanks a lot for pointing this out, we can further simplify patch 3 with that.

The advice elsewhere in this thread is that perhaps leaving this as-is may
be best after all.

* https://lore.kernel.org/netdev/63c6825fc2c94ad19ac7de93a6f151f6@AcuMS.aculab.com/
