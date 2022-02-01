Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECC1E4A6442
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 19:53:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242054AbiBASx0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 13:53:26 -0500
Received: from mail-bn8nam12on2056.outbound.protection.outlook.com ([40.107.237.56]:20961
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242043AbiBASxZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Feb 2022 13:53:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d+4OzUrEfmhkF+5R6yYLMHJLNAMDoic1IpLi5aw1iC8TAFFb5cgc70CScIR6tjPslk7QyDq4oU+1sn/fk3dVrI+tSsN3ivwEXVDv7XOAMABxVQZu6jeJ3MXDswE1S0l9hxSWSxq5gXWzymY00gX70ryMPE/w27V64EI9WVI9kDsvBhv0GVbhbAJurp2KfP79Y9fPeCVINay8oOGQA8dfv3NbhR+GcAH7e141cTqXRsi172U4huuClEv+3znJroxziywMLKzhYpO6WQoi1EVL3f78ezlvymmuG7k6M3v4/uUTVsEdnXwAJNXFRP0l8QNn1jBjCmOrdDA7BTnvyIX/qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j22xXxJKHeIAXK9X4iBbNwYLMUh1GGElowZzRY+Jmm8=;
 b=h1eJ3pHxdl6U/LzsikcV6RtUvTqD+yCbOP19ZravxUbMmcu9h6RI4ja6Y2fuEEc8Pr+ZBZqg6W3ubAl2uvnQo9Z1nDvfExWPI9YQwRS3Nw2w5j4GM7iGpro1dIizZKY1pJb/+m+Cq0YJ3XRDtLWd5e8o8jkFqqltpoElkiHvYPqKFSC2pvil+uRQ+wuh3qCudsZVtt2WM10Fi8mwDt+HeYEj5mjVUQBb34PwjK1QiyLiTtoSXqJ0A+tLy37gEMfsv34/Ctqy1xf8prxWmbOkHXPjUQwLl9xjgFwo2rvpJc08Q4jG/tsPUDdcTkmwwq+370gVifx4zKd0AEzL2xLVzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j22xXxJKHeIAXK9X4iBbNwYLMUh1GGElowZzRY+Jmm8=;
 b=ronwKqt9ektotO5dxlIKgPkLRheD7/3gOOId38H3NqhbAZBsUzrnkSwsx71wfScovv5DHQbX0qmds1JPMTi4eI4l8Q1hkZzj0vLv6elgN5pWSOV8dTTqFzeKu4puZacrQ+HHzwIoepzczV9Wzaa3jTXrYphDAwsluWuIj+vSP36wL8VKzsQ+UtzFAP1bZaX51fSwLzp8UJR+HOHB5jCyDRsQRkft9RtILMkUJ4/gQyZG7k6iHl5InhGzhY9DFJAPMQM+Ura+K8+Q1QQoDv/f7aM9yk8RwmaU2gA0xRlyhQokKbPZewbWJbs/A6gUQmUueSdzdVQJKJsG5xnoE/LMCA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB3051.namprd12.prod.outlook.com (2603:10b6:5:119::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.19; Tue, 1 Feb
 2022 18:53:23 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4930.022; Tue, 1 Feb 2022
 18:53:22 +0000
Date:   Tue, 1 Feb 2022 14:53:21 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V6 mlx5-next 09/15] vfio: Extend the device migration
 protocol with RUNNING_P2P
Message-ID: <20220201185321.GM1786498@nvidia.com>
References: <20220130160826.32449-1-yishaih@nvidia.com>
 <20220130160826.32449-10-yishaih@nvidia.com>
 <20220201113144.0c8dfaa5.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220201113144.0c8dfaa5.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1PR13CA0320.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::25) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eab5c3c1-f4a1-4ab4-596c-08d9e5b41eec
X-MS-TrafficTypeDiagnostic: DM6PR12MB3051:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB305184F1AB39B2B4F9E41678C2269@DM6PR12MB3051.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gMXztykR9jc6ZwzD50QJ5KcwWptrJpnfeiYGUqs9pStt4bcrxRz9g6MJ4aRmzVrt1iS7bpw8cvfq9zyUSn+JsVP6AXhJUoOfkqoAlMYRGceefV77Gzwk3kFCsD1V9vf9MeSEOGJQ4qoMNNRwQ8kiWEDwXP25kpY0VAUrqvaFiNsbEbUlC1C+g+c4kKePfj1775vfpQbNNjpKqQE/hiVnRZ5SGuAlRIgdotcJunEhUuVpjji8AErnN0rFDxR79dmixcog23YqYHZmNsdlPvRLUkzHyhU/f3JTK2iCDblfTljh8USTWDCg/8eYU0MCvEZsdCt7uSVuKiWE3TBsjyvGHMi0PvGchnhstly/QZh4+orpEvLRcXvSgRn71rTL+zVlDhkCa/qU3rDrwh63DGB+RNHWaCbXIUcYumeXG4pweuRIGgdY4Y3gHe7lx3zk1++cETsvMnZCP9ijCxsSm1cJhpbz6hrT7oKgwQVIk6gtVKoXzNxbflMsJA3JHviL5jP0PQ/t8CGbKqMaHF+S6heHHGcjxEWuNJ5NEftlRlOQ/SWBqkGe5SM78UNYlUDPHXbq02DO4IOCnvYfR55D63p7nelPUH50+2UciT6EX6Q1iyXhn8j8u2AFFEME1Ef9sZ6vIQuiZMHYmXqEbAW2bslcUA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66476007)(1076003)(508600001)(316002)(6506007)(26005)(66946007)(66556008)(5660300002)(8676002)(6512007)(4326008)(186003)(8936002)(2906002)(38100700002)(2616005)(6916009)(86362001)(107886003)(33656002)(83380400001)(6486002)(36756003)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?n/7/ELSQhVIfTJfW0uADB06067MmNjryTFq1G+4gsNKujoGDOKQ50G3qn+II?=
 =?us-ascii?Q?bSAzMmDkuhmznriVVKidd4lj/JyvvjWegD2ql/NrNwKw0/Gm0uJNvPVL390Z?=
 =?us-ascii?Q?UzEQgKWwQksvkyZAYxzAUWNjT+tR1Un+1DfVcJqAQh4S9ZtPa6Q5tT7+jDqg?=
 =?us-ascii?Q?lFWDCYbee+9BSDUKbab2Gm5J3IsDpsISUzx2kxh/sFDmFGxclR0YDtxpNDE0?=
 =?us-ascii?Q?Ta7ydp950yoxGKWXKxFybpf/n4wbADZOfsn2/zxvyhYt2w7oKdaroHWmLI+z?=
 =?us-ascii?Q?L5xWDYLZ+w7BzfbEC3E5xza80QPE/QegScXU1DfACTRyrIHEif9ZI6iSJBog?=
 =?us-ascii?Q?rtibEjmtN23+z7ikiVWBt5UJtbSFT4usgvgq1pgFrBzDmBOd/GgDpWIHFaFB?=
 =?us-ascii?Q?eMCqAyu/q9TTOqr3oIw0jdzMbwtD30UVXlkqXEqDkwWEsBxqhGDqpW/X3H4m?=
 =?us-ascii?Q?n2W0mGyrk5KEnlvFcWC2tf05t6QYruhUGAyn7Q8DjCCuYjLVZM8p7UXn7jrM?=
 =?us-ascii?Q?mOrQb9XjFlVa378xq30ND4jDvJflw1Io1ATDair01oeSjRZUCEgGlPT6hO0x?=
 =?us-ascii?Q?tlWc6P7OAAWQ1/T5A6m2+lPsGdDgtNOG2ePa37h0zgnvQFvwoIBdMvbKlWnj?=
 =?us-ascii?Q?0IsD7JiPiXWl4pAXEV4Av994iNX8kWBOKOWR/uoMwFrkWbz9tIAuaaIiKGBu?=
 =?us-ascii?Q?5ki4EEbOia9iw5/mZXXxd+TUdzq5Aj1SH7OW6+/nXF2O1OvsmefDgIlEkko3?=
 =?us-ascii?Q?6M3rgYZPvw7j9GfSfYtTlj6gs1rEBOwJ8iUbxogsd0fN5dZR1CulYUX9QBre?=
 =?us-ascii?Q?j0wa2XjOxAXnxi+dNCJ3OfKpE3dRvMoYqmIlG4ciUQ6mqjhDE4QnEx49aShO?=
 =?us-ascii?Q?2WUKJYzFudwFygMHL3w2NkV3Qr+zt2AONJaesMiBivomqioBH4rhonBkHfC+?=
 =?us-ascii?Q?0OP7UITrvOMUtlwyRuNMCSzHOud0QKiqsSbC/wdrcNzDbMUWqfAZPuRSPfn/?=
 =?us-ascii?Q?e14J3bYed3LWHzSOumwW7rQGV8Ecjck1EVk2X3hI/pf1qRBbLPam7V7IxZdo?=
 =?us-ascii?Q?f7gmPijpfh1cfck+xyml4WUu9F8NeoNc94dNm9xYC7zke3KkfJ9StvqdqMX1?=
 =?us-ascii?Q?SExOoZrvmsaqNrq8LlNXckR4yDrxPa0NE78zxCvZ/2WNrOjye1tkuD/yP/ro?=
 =?us-ascii?Q?MjbBnB+YeCUYDzMgObY+xYkEgwjdsPhByIweqs74OaojH0kJpshFaOFB8w2e?=
 =?us-ascii?Q?k1EKD5sZxvspMtRFgm5Uq16YHrmn6zCj7F2jLS5vt/ipsiZs2Wj95vSIAqI2?=
 =?us-ascii?Q?g7CipKiISqUzxaIW4/tEqGPEpSywDRiGR4sA7fd1WtMcOIhQvtHzfostXIps?=
 =?us-ascii?Q?MF9sztLkr9Yjd2yG6+sdMTIzligkAEuaAIbis1g2SpNgtLjXrN9pXozfj62X?=
 =?us-ascii?Q?yHGJRDmTtGdRmIDJ5KxhRz/DyE51qTsBG73AyWoJN46+ONnGPWywXTh2xMQz?=
 =?us-ascii?Q?nLAcbnz68eIuINf0A0fMxvaG6Vc/y5DhL69OlvJFXdLjeQWah5S4w5v+Pbig?=
 =?us-ascii?Q?bJHrbk3yfSmOEjo72BU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eab5c3c1-f4a1-4ab4-596c-08d9e5b41eec
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2022 18:53:22.7815
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nQANp5Y2VBwfyO6Sea7kJy7REtej+/uuBQm/8pdIFeAffTmbxmu7GTPPAQA0gZu1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3051
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 01, 2022 at 11:31:44AM -0700, Alex Williamson wrote:
> > +	bool have_p2p = device->migration_flags & VFIO_MIGRATION_P2P;
> > +
> >  	if (cur_fsm >= ARRAY_SIZE(vfio_from_fsm_table) ||
> >  	    new_fsm >= ARRAY_SIZE(vfio_from_fsm_table))
> >  		return VFIO_DEVICE_STATE_ERROR;
> >  
> > -	return vfio_from_fsm_table[cur_fsm][new_fsm];
> > +	if (!have_p2p && (new_fsm == VFIO_DEVICE_STATE_RUNNING_P2P ||
> > +			  cur_fsm == VFIO_DEVICE_STATE_RUNNING_P2P))
> > +		return VFIO_DEVICE_STATE_ERROR;
> 
> new_fsm is provided by the user, we pass set_state.device_state
> directly to .migration_set_state.  We should do bounds checking and
> compatibility testing on the end state in the core so that we can

This is the core :)

> return an appropriate -EINVAL and -ENOSUPP respectively, otherwise
> we're giving userspace a path to put the device into ERROR state, which
> we claim is not allowed.

Userspace can never put the device into error. As the function comment
says VFIO_DEVICE_STATE_ERROR is returned to indicate the arc is not
permitted. The driver is required to reflect that back as an errno
like mlx5 shows:

+		next_state = vfio_mig_get_next_state(vdev, mvdev->mig_state,
+						     new_state);
+		if (next_state == VFIO_DEVICE_STATE_ERROR) {
+			res = ERR_PTR(-EINVAL);
+			break;
+		}

We never get the driver into error, userspaces gets an EINVAL and no
change to the device state.

It is organized this way because the driver controls the locking for
its current state and thus the core code caller along the ioctl path
cannot validate the arc before passing it to the driver. The code is
shared by having the driver callback to the core to validate the
entire fsm arc under its lock.

The driver ends up with a small while loop that will probably be copy
and pasted to each driver. As I said, I'm interested to lift this up
as well but I need to better understand the locking needs of the other
driver implementations first, or we need your patch series to use the
inode for zap to land to eliminate the complicated locking in the
first place..

> Testing cur_fsm is more an internal consistency check, maybe those
> should be WARN_ON.

Sure
 
> > +
> > +	cur_fsm = vfio_from_fsm_table[cur_fsm][new_fsm];
> > +	if (!have_p2p) {
> > +		while (cur_fsm == VFIO_DEVICE_STATE_RUNNING_P2P)
> > +			cur_fsm = vfio_from_fsm_table[cur_fsm][new_fsm];
> > +	}
> 
> Perhaps this could be generalized with something like:

Oh, that table could probably do both tests, if the bit isn't set it
is an invalid cur/next_fsm as well..

Thanks,
Jason
