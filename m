Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16DE3690122
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 08:21:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbjBIHVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 02:21:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbjBIHVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 02:21:36 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2053.outbound.protection.outlook.com [40.107.93.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C01151B33C
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 23:21:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZElNje04JlVFxNNKbLtUHy629x0ntFhf4qARLCKS2fiu1H+yXjKPH5PFjwShG5hLTNEdcJYryPxOhHlZ1nTBSLyrOFtMOpbOq96jZb52DyxO+s2kPDEaSwrQoPP4sByg9mVoOPG8QXMnzSagjUwUCTcGs47P6KohjERXhUVTK3cjHlj1kXKAk7U/o9ahbXwIICZtgCuNuPeWLPhd8x9xiolSTI/f+dJpiaBfVqJoal+E1OUO3hY6mY1m0bM6y6eadFuG3gq7h+w/rm2XQm5oK2AqN/tpYN+ed/GCpFDPYsRKmoxtGZTkG6jDSgymaBbnxrRdkdeh2zCaYL2jwpGKBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ma0lMYhmkgsFbsPUuCcNQ33R7PVCiMwdt8Gw3JCvLBw=;
 b=ikP8ce07O+1bacLbjkg3rKTPDKxix1i9eForscfs38rXw3C9LaRunJLZEAyul7UJkcVJETDVZ2bKMNRw406vUzw+gozVsPnYumlR0N6qGFLwTXiF8m2olXUQeuIvvqTsXMCrp+5gPnI3f5FBxjLyNvZnUK0UuLrRQJ1xaW94fmnbbE3UpfFn2Ukpi5mcti0onIMzMalIftj0Rj0p7lLH6rlFxDgxIhEcEfUdsRKHIC99oM2/lkj96nKRFVOiy+YkGkDhyrDyaNHyHeD0o+a9ujYNiugMXvFRFLTxw/KA0DKmrHXjENKhZkGW7MhuqDSIvBEx1Aq0dU87K+T8ZxBa3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ma0lMYhmkgsFbsPUuCcNQ33R7PVCiMwdt8Gw3JCvLBw=;
 b=MFLFd+7TpokBjGiqzXgb5kl0echq8+d5Bu55ymy29FUxCS2dkPN/QfdM16U8ptkEJImMXlOGOgRmE8cDrr/Wjy75XfVeQrfLvYnOmIEDp8H17deuuI9OsBxlhLO00cxvZNEn2pSWrccEqSeURKLF8P+sy+Os837mvFRjzlP5Za/jj34SzFb9j3GjPPNWs4Kv5MajLUoYcJeY7p9d7tChGxGFascRpoLJNK9Oi2XFsUNZg55KzMwwHgmeIU67Hkoci/hQXaqno/6tkniSPe/urDrE4ktAPXQ/uBswGJAMcJYpu5yoahdCW11rIIGoy/tTqxuX9Vl1MIW9qcQFhsNP0w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CY8PR12MB7755.namprd12.prod.outlook.com (2603:10b6:930:87::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Thu, 9 Feb
 2023 07:19:59 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::7d2c:828f:5cae:7eab]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::7d2c:828f:5cae:7eab%9]) with mapi id 15.20.6064.035; Thu, 9 Feb 2023
 07:19:59 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, razor@blackwall.org, roopa@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 4/4] selftests: forwarding: Add MDB dump test cases
Date:   Thu,  9 Feb 2023 09:18:52 +0200
Message-Id: <20230209071852.613102-5-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230209071852.613102-1-idosch@nvidia.com>
References: <20230209071852.613102-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0071.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:59::24) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|CY8PR12MB7755:EE_
X-MS-Office365-Filtering-Correlation-Id: fdcc49e4-da08-4206-3443-08db0a6e0dc6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vAZaRuaDh7IOHdwin6UDQ8KvTiZ79nZXNKhv1fuxeUoAXjaX88rJ5ZbugoNmCqeIYqbA08Ib6Is6L1O/6HeDH8NVNj+BoX6Xna4DTciComyI8A2lWRrVlbc3PdR+8wvKyXYtyWIk9haHhVrcvDdQmW6mhRHSA9K8k5EoA/VT+5HMh2NCGNk4N9u6JIeUqCrzBjTICEJCi7Rfss2NZl1nhJrJ0OYyOmUZZ9ViZEaKNtb0tmJpWlKhz/kgb2g8zZABCpvkxN5nsmQ3lrTEKIm5i4SPdC4BhSRkGOjJ4c7GhDAD7swDfb5wTfvE8cRNvVDyC/XmvfkP3lxRjldPEp8XmR95yCmZh/Vqnbewv+VmF4Li5IintGHEcv41B/Rs4eWip8GT04HCD60l7q2erMAM7qYuv75KB2vBYFpLW4MNwKL0ONOmEP+We4tX/87cQF0JinYplB63I4Cxy/yllgknCU8a/VL/hb5nJP8pQ4uTa5Ue2kubg+7ABdXlCRWrEtjJcPXQcl/z2jckq5UVVWVYad1YKA5d3pE57IuCtkAvknWRl/IBvfvW7UGWE5rL46gSv8p2lF/mrb0aZKNXFfnmusSrSt4j72TuPFJCr0/n1olYhS3AyMYRxw4SYJ0rMCs+LgCmEGwC/fOeTevnJQdHxA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(366004)(39860400002)(396003)(346002)(451199018)(6512007)(2906002)(186003)(6506007)(1076003)(26005)(36756003)(107886003)(6666004)(5660300002)(478600001)(6486002)(8936002)(41300700001)(2616005)(8676002)(66946007)(4326008)(66476007)(83380400001)(66556008)(86362001)(38100700002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mX1QtRU2JgQJmkDz0VLX829l4/KDJ4jkDA1xjqzv6nPZPHXzKgOJOe7sLL1H?=
 =?us-ascii?Q?IylFAmIppGlgbrWIr0ApMm0KHa+kEWfVBaQnuMq/6ACLlG91CTpgZy7eJCw5?=
 =?us-ascii?Q?82E0j6Fe0wV/huo/69NzSY1RcvhevMlwIgtfEfsQLtn9DOJX78ZoiaW385w+?=
 =?us-ascii?Q?ReA+io3ey08dfCHq8qAWswjoz5EakJfrzPWHSIUDphdtyYXEei5GgrvErQAK?=
 =?us-ascii?Q?seAeB1sXOCTFP/53x2uiUCW+58LTylvPH6H2mMbN0WEQZyPw3fIAaNY3eufB?=
 =?us-ascii?Q?F6dYF/qOAjBba6xKxYIOsNVV2Rsaa6/08PKYSw1A/SBLUM0lgRmTnDpqUJBo?=
 =?us-ascii?Q?Hle7BV/A/nlqFRZmPY/aw4GbQ7JLxtIBhS3jFQ1mZsuXhL5iWZmCoG75Sr7/?=
 =?us-ascii?Q?eTZjT6UPI2yoaaYDZTtVSWk7/0isVLmfDgrQmhkc7rpSQUsO7G+eOJMi5EFD?=
 =?us-ascii?Q?rDWxLt3HrCZcaQbRhEqp+a8hQg6njRa4PtGr57hmPU3G6hU/CWZ+z/BVsA8x?=
 =?us-ascii?Q?8UkCv9U5yYTvULMVrmGZ3vHZG0NSUs5wu2rBeh2aqv7bj7/SNCAcn1ZRG18P?=
 =?us-ascii?Q?0unvTOQuYaq//4WH4IJxvpBGi6aP3fNFBhuZwstIEYEArR2k8YTo9alxHb3U?=
 =?us-ascii?Q?AMqn6nUtoDSVnKfyGXcJqRDTujqE44PyGNnd2YNFGkRpHVL4h4M8PrR674nF?=
 =?us-ascii?Q?AOcUXjzGEjvYMhd41OIXxarRV1jhco9GIyujaNMgkVLaADNXkq1qufEudsxQ?=
 =?us-ascii?Q?gFcn3HOAJ0hDvEB6UwzQoUw3o85AGWJXvyVm5QECwnqALQpztq90V7qRiZxB?=
 =?us-ascii?Q?ZJWVxCrLdSYIqmFe9X42DLQpiRdGbK9hR4ZUSbYYUmdfW8UVRhETU4LzuJ5E?=
 =?us-ascii?Q?bmjwfKvr33+2r2NLajFdfE/J/oO9slOVFpqwsfo5tSoD666MgH/3g9Xo/Pct?=
 =?us-ascii?Q?s2VLOxwijcKrf0eUgsdKvzvY8QioehXYstraFy03jQQu0ttn+v0MYGWS3SJG?=
 =?us-ascii?Q?j6cbbSko9UllJet8hzevKha6xk1Sl/uXVE0aAgx6kdSa0EpV+swA8iBgUYFi?=
 =?us-ascii?Q?gGOMhJMd/2EAtjww2mRrvo/cjvPGRkXIuQHj0vu+R1UmXmd1JkIG6V7ebWRA?=
 =?us-ascii?Q?nmWGJ7Jbv9NgJzwDrWiG1d9qWFoNILzMqdPDbtIwx1Lbedq73KXpX6+ARhqf?=
 =?us-ascii?Q?D2jDlAdWcKEzGYM9mZNDonhAndsO4/N6zruG/GLnwj+J2jEI7HHHG6jXRn/1?=
 =?us-ascii?Q?/YNV2oP6tjO5wGLjYeP2++ntypBVEna2A6ciu/hSBW82aCWAGY0zKIyQRzeR?=
 =?us-ascii?Q?0tso94fq9kTnmZvFfc5FJdfGhXRtPXXM+biC+PpZWhUZMsB5ZTuv4mDorSYm?=
 =?us-ascii?Q?qAhyoSGMuRWYinyIwTYx5catMjX+w70mC7W62HJZuv9TwkKdzR56DNy7AF8O?=
 =?us-ascii?Q?hWixumbO3Q4XQ7zajX94qDYEtcMo9IbXN4WwQ9APnk3Dc+SRnYI7ilHRzOWo?=
 =?us-ascii?Q?WlQWTRgW8BWGd+bpXPRzGfQu46OD82bxoPIVDhmmP39ooq8gn2S3JCQplQTH?=
 =?us-ascii?Q?dCgkesn8ezFKGZfIbsIao41bDq6C53R8tIAsBwXd?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdcc49e4-da08-4206-3443-08db0a6e0dc6
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 07:19:59.7924
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cye9b4MjBKnBvwOV7DSEXWqm/xRcPYwdoaogzZ+Dit0q8pWVY32EtNNFkIjQkLaL4R27oJjiy5MP477sjB3tfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7755
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The kernel maintains three markers for the MDB dump:

1. The last bridge device from which the MDB was dumped.
2. The last MDB entry from which the MDB was dumped.
3. The last port-group entry that was dumped.

Add test cases for large scale MDB dump to make sure that all the
configured entries are dumped and that the markers are used correctly.

Specifically, create 2 bridges with 32 ports and add 256 MDB entries in
which all the ports are member of. Test that each bridge reports 8192
(256 * 32) permanent entries. Do that with IPv4, IPv6 and L2 MDB
entries.

On my system, MDB dump of the above is contained in about 50 netlink
messages.

Example output:

 # ./bridge_mdb.sh
 [...]
 INFO: # Large scale dump tests
 TEST: IPv4 large scale dump tests                                   [ OK ]
 TEST: IPv6 large scale dump tests                                   [ OK ]
 TEST: L2 large scale dump tests                                     [ OK ]
 [...]

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 .../selftests/net/forwarding/bridge_mdb.sh    | 99 +++++++++++++++++++
 1 file changed, 99 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/bridge_mdb.sh b/tools/testing/selftests/net/forwarding/bridge_mdb.sh
index b48867d8cadf..ae3f9462a2b6 100755
--- a/tools/testing/selftests/net/forwarding/bridge_mdb.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_mdb.sh
@@ -742,10 +742,109 @@ cfg_test_port()
 	cfg_test_port_l2
 }
 
+ipv4_grps_get()
+{
+	local max_grps=$1; shift
+	local i
+
+	for i in $(seq 0 $((max_grps - 1))); do
+		echo "239.1.1.$i"
+	done
+}
+
+ipv6_grps_get()
+{
+	local max_grps=$1; shift
+	local i
+
+	for i in $(seq 0 $((max_grps - 1))); do
+		echo "ff0e::$(printf %x $i)"
+	done
+}
+
+l2_grps_get()
+{
+	local max_grps=$1; shift
+	local i
+
+	for i in $(seq 0 $((max_grps - 1))); do
+		echo "01:00:00:00:00:$(printf %02x $i)"
+	done
+}
+
+cfg_test_dump_common()
+{
+	local name=$1; shift
+	local fn=$1; shift
+	local max_bridges=2
+	local max_grps=256
+	local max_ports=32
+	local num_entries
+	local batch_file
+	local grp
+	local i j
+
+	RET=0
+
+	# Create net devices.
+	for i in $(seq 1 $max_bridges); do
+		ip link add name br-test${i} up type bridge vlan_filtering 1 \
+			mcast_snooping 1
+		for j in $(seq 1 $max_ports); do
+			ip link add name br-test${i}-du${j} up \
+				master br-test${i} type dummy
+		done
+	done
+
+	# Create batch file with MDB entries.
+	batch_file=$(mktemp)
+	for i in $(seq 1 $max_bridges); do
+		for j in $(seq 1 $max_ports); do
+			for grp in $($fn $max_grps); do
+				echo "mdb add dev br-test${i} \
+					port br-test${i}-du${j} grp $grp \
+					permanent vid 1" >> $batch_file
+			done
+		done
+	done
+
+	# Program the batch file and check for expected number of entries.
+	bridge -b $batch_file
+	for i in $(seq 1 $max_bridges); do
+		num_entries=$(bridge mdb show dev br-test${i} | \
+			grep "permanent" | wc -l)
+		[[ $num_entries -eq $((max_grps * max_ports)) ]]
+		check_err $? "Wrong number of entries in br-test${i}"
+	done
+
+	# Cleanup.
+	rm $batch_file
+	for i in $(seq 1 $max_bridges); do
+		ip link del dev br-test${i}
+		for j in $(seq $max_ports); do
+			ip link del dev br-test${i}-du${j}
+		done
+	done
+
+	log_test "$name large scale dump tests"
+}
+
+# Check large scale dump.
+cfg_test_dump()
+{
+	echo
+	log_info "# Large scale dump tests"
+
+	cfg_test_dump_common "IPv4" ipv4_grps_get
+	cfg_test_dump_common "IPv6" ipv6_grps_get
+	cfg_test_dump_common "L2" l2_grps_get
+}
+
 cfg_test()
 {
 	cfg_test_host
 	cfg_test_port
+	cfg_test_dump
 }
 
 __fwd_test_host_ip()
-- 
2.37.3

